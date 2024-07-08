import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/Model/chat_contact.dart';
import '../../data/Model/enum/message_enum.dart';
import '../../data/Model/message.dart';
import '../../data/Model/message_reply.dart';
import '../../data/Model/user_model.dart';
import '../../data/repository/chat_repository/chat_repository.dart';

class ChatController extends GetxController {
  ChatRepository chatRepository = Get.put(ChatRepository());

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Future<void> sendTextMessage({
    required String text,
    required String receiverUserId,
  }) async {
    var messageReply = Rxn<MessageReply>();

    final UserModel senderUser = Get.find<UserModel>();

    await chatRepository.sendTextMessage(
      text: text,
      receiverUserId: receiverUserId,
      senderUser: senderUser,
      messageReply: messageReply.value,
    );
    messageReply.value == null;
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
  ) {
    var messageReply = Rxn<MessageReply>();

    final UserModel senderUser = Get.find<UserModel>();

    chatRepository.sendFileMessage(
      context: context,
      file: file,
      recieverUserId: recieverUserId,
      senderUserData: senderUser,
      messageEnum: messageEnum,
      messageReply: messageReply.value,
    );
    messageReply.value == null;

  }

  void sendGIFMessage(
      String gifUrl, String recieverUserId, BuildContext context) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    final UserModel senderUser = Get.find<UserModel>();
    var messageReply = Rxn<MessageReply>();

    chatRepository.sendGIFMessage(
        gifUrl: newGifUrl,
        receiverUserId: recieverUserId,
        senderUser: senderUser,
        context: context,
        messageReply: messageReply.value,

    );
    messageReply.value == null;

  }
  void setChatMessageSeen(
      BuildContext context,
      String recieverUserId,
      String messageId,
      ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
