import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_app/controller/call_view_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../data/Model/user_model.dart';
import '../../utils/zego_cloud_config.dart';

class AudioCallScreen extends StatelessWidget {
  final UserModel target;
   AudioCallScreen({super.key, required this.target});
   CallViewModel callViewModel = Get.put(CallViewModel());
  
  @override
  Widget build(BuildContext context) {
    var callId = callViewModel.getRoomId(target.uid!);
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId,
      appSign: ZegoCloudConfig.appSign,
      userID: callViewModel.currentUser.value.uid ?? "root",
      userName: callViewModel.currentUser.value.name ?? "root",
      callID: callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}


