import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/status_controller/status_controller.dart';
import '../../res/color/app_color.dart';

class ConfirmStatusScreen extends StatelessWidget {
  final File file;
  ConfirmStatusScreen({super.key, required this.file});
  StatusController statusController = Get.put(StatusController());

  void addStatus(BuildContext context ){
    statusController.addStatus(file, context);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: AspectRatio(
            aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.tabColor,
          onPressed: () => addStatus(context),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        )
      ),
    );
  }
}
