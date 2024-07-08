import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_app/controller/auth/auth_controller.dart';
import '../../res/assets/image_asset.dart';
import '../../res/color/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../res/size_config/size_config.dart';
import '../../res/widget/custom_button.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getHeight(50)),
              Text(
                'Welcome To Whatsapp',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getFont(33),
                ),
              ),
              SizedBox(height: getHeight(80)),
              Image.asset(
                ImageAssets.landingPageScreenLogo,
                height: getHeight(340),
                width: getWidth(340),
                color: AppColor.tabColor,
              ),
              SizedBox(height: getHeight(80)),
              Text(
                'Read Our Privacy Policy. Tap "Agree and continue" to\n accept the Terms of Services',
                style: TextStyle(
                  color: AppColor.greyColor,
                  fontWeight: FontWeight.w400,
                  fontSize: getFont(14),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getHeight(20)),
              CustomButton(
                width: getWidth(260),
                height: getHeight(60),
                radius: BorderRadius.circular(10),
                onPress: () {
                  _showBottomSheet(context);
                },
                textStyle: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: getFont(16),
                  fontWeight: FontWeight.w600,
                ),
                title: 'Agree And Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              width: getWidth(260),
              height: getHeight(60),
              radius: BorderRadius.circular(10),
              onPress: () {
                // Add your logic for continuing with phone number
                Get.toNamed(RouteName.loginScreen);
              },
              textStyle: TextStyle(
                color: AppColor.whiteColor,
                fontSize: getFont(16),
                fontWeight: FontWeight.w600,
              ),
              title: 'Continue with Phone Number',
            ),
            SizedBox(height: getHeight(20)),
            CustomButton(
              width: getWidth(260),
              height: getHeight(60),
              radius: BorderRadius.circular(10),
              onPress: () {
                // Add your logic for continuing with Google email
                authController.sigInWithGoogle();

              },
              textStyle: TextStyle(
                color: AppColor.whiteColor,
                fontSize: getFont(16),
                fontWeight: FontWeight.w600,
              ),
              title: 'Continue with Google Email',
            ),
          ],
        ),
      ),
      //isScrollControlled: true, // This makes the bottom sheet full height
    );
  }
}
