import 'dart:io';
import 'package:get/get.dart';
import 'package:whatsapp_app/data/Model/user_model.dart';
import 'package:whatsapp_app/res/routes/routes_name.dart';
import '../../data/Model/status_model.dart';
import '../../view/auth/login_screen.dart';
import '../../view/auth/otp_screen.dart';
import '../../view/auth/user_information_screen.dart';
import '../../view/chat/mobile_chat_screen.dart';
import '../../view/landing/landing_screen.dart';
import '../../view/mobile_layout/mobile_layout_screen.dart';
import '../../view/select_contact/select_contact_screen.dart';
import '../../view/splash_screen/splash_screen.dart';
import '../../view/status/confirm_status_screen.dart';
import '../../view/status/status_screen.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: RouteName.landingScreen,
      page: () =>  LandingScreen(),
    ),
    GetPage(
      name: RouteName.loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: RouteName.otpScreen,
      page: () => OtpScreen(verificationId: Get.arguments as String), // Ensure Get.arguments is a String
    ),
    GetPage(
      name: RouteName.userInformationScreen,
      page: () => const UserInformationScreen(),
    ),
    GetPage(
      name: RouteName.selectContactScreen,
      page: () => const SelectContactsScreen(),
    ),
    GetPage(
      name: RouteName.mobileChatScreen,
      page: () => MobileChatScreen(
        name: (Get.arguments as Map)['name'] as String? ?? '', // Default to empty string if null
        uid: (Get.arguments as Map)['uid'] as String? ?? '', // Default to empty string if null
        isGroupChat: (Get.arguments as Map)['isGroupChat'] as bool? ?? false, // Default to false if null
        profilePic: (Get.arguments as Map)['profilePic'] as String? ?? '',
        userModel: (Get.arguments as UserModel) // Default to empty string if null
      ),
    ),
    GetPage(
      name: RouteName.mobileLayOutScreen,
      page: () => const MobileLayoutScreen(),
    ),
    GetPage(
      name: RouteName.confirmStatusScreen,
      page: () => ConfirmStatusScreen(file: Get.arguments as File), // Ensure Get.arguments is a File
    ),
    GetPage(
      name: RouteName.statusScreen,
      page: () => StatusScreen(status: Get.arguments as Status), // Ensure Get.arguments is a Status object
    ),
  ];
}
