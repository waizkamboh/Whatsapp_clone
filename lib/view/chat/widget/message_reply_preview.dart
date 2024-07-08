import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/message_reply_controller/message_reply_controller.dart';
import '../../../res/widget/display_text_image_gif.dart';


class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply() {
    Get.find<MessageReplyController>().cancelReply();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageReplyController>(
      builder: (controller) {
        final messageReply = controller.messageReply.value;

        if (messageReply == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: 350,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      messageReply.isMe ? 'Me' : 'Opposite',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: cancelReply,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DisplayTextImageGif(
                message: messageReply.message,
                type: messageReply.messageEnum,
              ),
            ],
          ),
        );
      },
    );
  }
}
