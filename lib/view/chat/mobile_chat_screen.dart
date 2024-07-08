import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_app/controller/call_view_model.dart';
import 'package:whatsapp_app/view/call/audio_call_screen.dart';
import 'package:whatsapp_app/view/call/video_call_screen.dart';
import 'package:whatsapp_app/view/chat/widget/bottom_chat_field.dart';
import 'package:whatsapp_app/view/chat/widget/chat_list.dart';
import '../../controller/auth/auth_controller.dart';
import '../../data/Model/user_model.dart';
import '../../res/color/app_color.dart';
import '../../res/widget/loader.dart';


class MobileChatScreen extends StatelessWidget {
  final UserModel userModel;
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  MobileChatScreen({super.key, required this.userModel, required this.name, required this.uid, required this.isGroupChat, required this.profilePic});
  AuthController authController = Get.put(AuthController());
  CallViewModel callViewModel = Get.put(CallViewModel());



  @override
  Widget build(BuildContext context) {
    // final arguments = Get.arguments as Map<String, dynamic>;
    // final String name = arguments['name'];
    // final String uid = arguments['uid'];

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        title: StreamBuilder<UserModel>(
          stream: authController.userDataById(userModel.uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userModel.profilePic!),

              ),
              title: Text(name),
              subtitle: Text(
                snapshot.data!.isOnline! ? 'online' : 'offline',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),

            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {
              Get.to(AudioCallScreen(target: userModel));
              callViewModel.callAction(
                  userModel, callViewModel.currentUser.value,  "audio"
              );
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              Get.to(VideoCallScreen(target: userModel));
              callViewModel.callAction(
                  userModel, callViewModel.currentUser.value, "video");
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverUserId: userModel.uid!),
          ),
          BottomChatField(recieverUserId: userModel.uid!),
        ],
      ),

    );
  }
}