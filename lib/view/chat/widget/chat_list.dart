import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_app/view/chat/widget/sender_message_card.dart';
import '../../../controller/chat_controller/chat_controller.dart';
import '../../../controller/message_reply_controller/message_reply_controller.dart';
import '../../../data/Model/enum/message_enum.dart';
import '../../../data/Model/message.dart';
import '../../../data/Model/message_reply.dart';
import '../../../res/widget/loader.dart';
import 'my_message_card.dart';



class ChatList extends StatefulWidget {
  final String recieverUserId;
  const ChatList({super.key, required this.recieverUserId});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatController chatController = Get.put(ChatController());
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
      String message,
      bool isMe,
      MessageEnum messageEnum,
      ) {
    final messageReplyController = Get.find<MessageReplyController>();
    messageReplyController.setMessageReply(
      MessageReply(
        message,
        isMe,
        messageEnum,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: chatController.chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);
            if (!messageData.isSeen &&
                messageData.recieverid ==
                    FirebaseAuth.instance.currentUser!.uid) {
              chatController.setChatMessageSeen(
                context,
                widget.recieverUserId,
                messageData.messageId,
              );
            }
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                userName: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(messageData.text, true, messageData.type),
                isSeen: messageData.isSeen,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              repliedText: messageData.repliedMessage,
              userName: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe: () => onMessageSwipe( messageData.text, false, messageData.type),
            );
          },
        );
      },
    );
  }
}
