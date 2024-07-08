import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/utils.dart';
import '../../Model/chat_contact.dart';
import '../../Model/enum/message_enum.dart';
import '../../Model/message.dart';
import '../../Model/message_reply.dart';
import '../../Model/user_model.dart';
import '../common/common_firebase_storage.dart';

class ChatRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  CommonFirebaseStorageRepository commonFirebaseStorageRepository = Get.put(CommonFirebaseStorageRepository());




  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name!,
            profilePic: user.profilePic!,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Future<void> sendTextMessage({
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,

  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      var userDataMap =
      await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      // Save data to contacts subcollection
      await _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      // Save message to message subcollection
      await _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUserName: receiverUserData.name,
        username: senderUser.name!,
        messageReply: messageReply,
        recieverUserName: receiverUserData.name,
        senderUsername: senderUser.name!,
      );
    } catch (e) {
      toastMessage(e.toString());
    }
  }

  Future<void> _saveDataToContactsSubcollection(
      UserModel senderUserData,
      UserModel? receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId,
      ) async {
    // users -> receiver user id => chats -> current user id -> set data
    var receiverChatContact = ChatContact(
      name: senderUserData.name!,
      profilePic: senderUserData.profilePic!,
      contactId: senderUserData.uid!,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
      receiverChatContact.toMap(),
    );
    // users -> current user id  => chats -> receiver user id -> set data
    var senderChatContact = ChatContact(
      name: receiverUserData!.name!,
      profilePic: receiverUserData.profilePic!,
      contactId: receiverUserData.uid!,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
      senderChatContact.toMap(),
    );
  }

  Future<void> _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String? receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
     // receiverId: receiverUserId,
      recieverid: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
          ? senderUsername
          : recieverUserName ?? '',
      repliedMessageType:
      messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    // users -> sender id -> receiver id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
      message.toMap(),
    );
    // users -> receiver id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
      message.toMap(),
    );
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await commonFirebaseStorageRepository
          .storeFileToFirebase(
        'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
        file,
      );

      UserModel? recieverUserData;

        var userDataMap =
        await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);


      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _saveDataToContactsSubcollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name!,
        receiverUserName: recieverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        recieverUserName: recieverUserData.name,
        senderUsername: senderUserData.name!,

      );
    } catch (e) {
      toastMessage(e.toString());
    }
  }

  Future<void> sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,

  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      var userDataMap =
      await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      // Save data to contacts subcollection
      await _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        'GIF',
        timeSent,
        receiverUserId,
      );

      // Save message to message subcollection
      await _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        receiverUserName: receiverUserData.name,
        username: senderUser.name!,
        messageReply: messageReply,
        recieverUserName: receiverUserData.name,
        senderUsername: senderUser.name!,
      );
    } catch (e) {
      toastMessage(e.toString());
    }
  }
  void setChatMessageSeen(
      BuildContext context,
      String recieverUserId,
      String messageId,
      ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      toastMessage(e.toString());
    }
  }
}
