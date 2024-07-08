import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/auth_controller.dart';
import '../../res/color/app_color.dart';
import '../../res/size_config/size_config.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId, });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthController authController = Get.put(AuthController());
  final String verificationId = Get.arguments ?? '';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: AppColor.backgroundColor,
        leading: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: getHeight(20),),
            const Text('We have sent an SMS with a code'),
             SizedBox(
               width: getWidth(180),
               child: TextField(
                 textAlign: TextAlign.center,
                controller: authController.verificationCode.value,
                decoration:  InputDecoration(
                  hintText: '_ _ _ _ _ _',
                  hintStyle: TextStyle(
                    fontSize: getFont(30),
                  ),


                ),
                keyboardType: TextInputType.number,
                 onChanged: (value){
                  if(value.length == 6){
                    authController.verifyOTP(context,verificationId, authController.verificationCode.value.text);

                  }
                 },
                           ),
             )


          ],
        ),
      ),

    );
  }
}
