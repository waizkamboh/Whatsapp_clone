import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/Model/status_model.dart';
import '../../data/repository/status_repository/status_repository.dart';
import '../auth/auth_controller.dart';


class StatusController extends GetxController {
  final StatusRepository statusRepository = Get.put(StatusRepository());
  final AuthController authController = Get.put(AuthController());

  void addStatus(File file, BuildContext context) {
    var userData = authController.currentUser.value;
    if (userData != null) {
      statusRepository.uploadStatus(
        username: userData.name!,
        profilePic: userData.profilePic!,
        phoneNumber: userData.phoneNumber!,
        statusImage: file,
        context: context,
      );
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    return await statusRepository.getStatus(context);
  }
}
