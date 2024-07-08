import 'package:get/get.dart';
import '../../data/Model/message_reply.dart';

class MessageReplyController extends GetxController {
  var messageReply = Rxn<MessageReply>();

  void setMessageReply(MessageReply? reply) {
    messageReply.value = reply;
  }

  void cancelReply() {
    messageReply.value = null;
  }
}
