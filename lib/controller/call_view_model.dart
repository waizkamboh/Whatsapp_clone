import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_app/data/Model/call_model.dart';
import 'package:whatsapp_app/data/Model/user_model.dart';
import 'package:whatsapp_app/view/call/audio_call_screen.dart';
import 'package:whatsapp_app/view/call/video_call_screen.dart';

class CallViewModel extends GetxController{
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final uuid = const Uuid().v1();
  Rx<UserModel> currentUser = UserModel().obs;

  String getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser!.uid;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return currentUserId + targetUserId;
    } else {
      return targetUserId + currentUserId;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCallNotification().listen((List<CallModel> callList){
      if(callList.isNotEmpty){
        var callData = callList[0];
        if (callData.type == "audio") {
          audioCallNotification(callData);
        } else if (callData.type == "video") {
          videoCallNotification(callData);
        }
      }
    });
  }

  Future<void> audioCallNotification(CallModel callData) async {
    Get.snackbar(
      duration: const Duration(days: 1),
      barBlur: 0,
      backgroundColor: Colors.grey[900]!,
      isDismissible: false,
      icon: const Icon(Icons.call),
      onTap: (snack) {
        Get.back();
        Get.to(
          AudioCallScreen(
            target: UserModel(
              uid: callData.callerUid,
              name: callData.callerName,
              phoneNumber: callData.callerPhoneNumber,
              profilePic: callData.callerPic,
            ),
          ),
        );
      },
      callData.callerName!,
      "Incoming Audio Call",
      mainButton: TextButton(
        onPressed: () {
          endCall(callData);
          Get.back();
        },
        child: const Text("End Call"),
      ),
    );
  }


  Future<void> callAction(UserModel receiver, UserModel caller, String type) async {
    String id = uuid;
    var newCall = CallModel(
      id: id,
      callerName: caller.name,
      callerPic: caller.profilePic,
      callerUid: caller.uid,
      callerPhoneNumber: caller.phoneNumber,
      receiverName: receiver.name,
      receiverPic: receiver.profilePic,
      receiverUid: receiver.uid,
      receiverPhoneNumber: receiver.phoneNumber,
      status: "dialing",
      type: type
    );

    try{
       await db
           .collection("notification")
           .doc(receiver.uid)
           .collection("call")
           .doc(id)
           .set(newCall.toJson());
       await db
           .collection("users")
           .doc(auth.currentUser!.uid)
           .collection("calls")
           .doc(id)
           .set(newCall.toJson());
       await db
           .collection("users")
           .doc(receiver.uid)
           .collection("calls")
           .doc(id)
           .set(newCall.toJson());
       Future.delayed(const Duration(seconds: 20), () {
         endCall(newCall);
       });
    }catch (e) {
       print(e);
    }

  }


  Stream<List<CallModel>> getCallNotification() {
    return db
        .collection("notification")
        .doc(auth.currentUser!.uid)
        .collection("call")
        .snapshots()
        .map((snapshot) => snapshot.docs
             .map((doc) => CallModel.fromJson(doc.data()))
        .toList());
  }

  Future<void> endCall(CallModel call) async{
    try{
      await db
          .collection("notification")
          .doc(call.receiverUid)
          .collection("call")
          .doc(call.id)
          .delete();
    }catch (e){
      print(e);
    }
  }

  void videoCallNotification(CallModel callData) {
    Get.snackbar(
      duration: const Duration(days: 1),
      barBlur: 0,
      backgroundColor: Colors.grey[900]!,
      isDismissible: false,
      icon: const Icon(Icons.video_call),
      onTap: (snack) {
        Get.back();
        Get.to(
          VideoCallScreen(
            target: UserModel(
              uid: callData.callerUid,
              name: callData.callerName,
              phoneNumber: callData.callerPhoneNumber,
              profilePic: callData.callerPic,
            ),
          ),
        );
      },
      callData.callerName!,
      "Incoming Video Call",
      mainButton: TextButton(
        onPressed: () {
          endCall(callData);
          Get.back();
        },
        child: const Text("End Call"),
      ),
    );
  }

  Stream<List<CallModel>> getCalls() {
    return db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("calls")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => CallModel.fromJson(doc.data()),
      )
          .toList(),
    );
  }

}