import 'package:get/get.dart';

class TypingIndicatorController extends GetxController {
  var isTyping = false.obs;

  void setTyping(bool typing) {
    isTyping.value = typing;
  }
}
