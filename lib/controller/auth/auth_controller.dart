import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/Model/user_model.dart';
import '../../data/repository/auth_repository/auth_repository.dart';


class AuthController extends GetxController {
  final AuthRepository authRepository = AuthRepository();
  var currentUser = Rxn<UserModel>();
  RxBool isLoading = false.obs;
  final phoneController = TextEditingController().obs;
  final verificationCode = TextEditingController().obs;
  final nameController = TextEditingController().obs;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    phoneController.close();
    verificationCode.close();
    nameController.close();
  }

 void sigInWithGoogle(){
    authRepository.signInWithGoogle();
 }
  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP,);
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      context: context,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
