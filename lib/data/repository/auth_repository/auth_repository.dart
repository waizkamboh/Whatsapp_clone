import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../Model/user_model.dart';


class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;


  Future<void> signInWithGoogle() async {
    try {
      // Begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // User canceled the sign-in process
        return;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally, sign in
      final UserCredential userCredential = await auth.signInWithCredential(credential);

      // If authentication is successful, navigate to the next screen
      if (userCredential.user != null) {
        Get.offNamed(RouteName.mobileChatScreen); // Replace RoutesName.nextScreen with your route name
      }
    } catch (e) {
      // Handle errors here
      Get.snackbar('Sign In Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signInWithPhone(BuildContext context,String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          toastMessage(e.message!);
          debugPrint(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Get.toNamed(RouteName.otpScreen, arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      toastMessage(e.message!);

    }
  }

  void verifyOTP({required BuildContext context, required String verificationId, required String userOTP,}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOTP,);
      await auth.signInWithCredential(credential);
      Get.offAllNamed(RouteName.userInformationScreen); // Using toNamed() for navigation
    } on FirebaseAuthException catch (e) {
      toastMessage(e.message!);
    }
  }

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }

  void saveUserDataToFirebase({required String name, required File? profilePic, required BuildContext context,}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      Get.offAllNamed(RouteName.mobileLayOutScreen); // Using toNamed() for navigation

    } catch (e) {
      toastMessage(e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({'isOnline': isOnline});
  }


}
