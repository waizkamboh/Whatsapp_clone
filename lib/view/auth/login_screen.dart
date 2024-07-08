import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/pick_country/pick_country_controller.dart';
import '../../res/color/app_color.dart';
import '../../res/size_config/size_config.dart';
import '../../res/widget/custom_button.dart';
import '../../utils/utils.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());
  CountryController countryController = Get.put(CountryController());



  void sendPhoneNumber() {
    String phoneNumber = authController.phoneController.value.text.trim();
    if (countryController.country.value != null && phoneNumber.isNotEmpty) {
      authController.isLoading.value = true;

     authController.signInWithPhone(context, '+${countryController.country.value!.phoneCode}$phoneNumber');
    } else {
      authController.isLoading.value = false;
      toastMessage('Fill out all the fields');
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: AppColor.backgroundColor,
        leading: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(18), vertical: getHeight(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Whatsapp will need to verify your phone number'.tr),
                SizedBox(height: getHeight(10),),
                TextButton(
                    onPressed: (){
                  countryController.pickCountry();

                }, child: const Text('Pick Country')),
                SizedBox(height: getHeight(5),),
                Row(
                  children: [
                    if(countryController.country.value != null)
                      Text('+${countryController.country.value!.phoneCode}'),
                    SizedBox(width: getWidth(10),),
                    SizedBox(
                      width: getWidth(250),
                      child: TextField(
                        controller: authController.phoneController.value,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: 'phone number'.tr,

                        ),
                      ),
                    )

                  ],
                ),

              ],
            ),


            //SizedBox(height: getHeight(480),),
            Column(
              children: [
                Obx(()=>
                CustomButton(
                    width: getWidth(90),
                    height: getHeight(50),
                    radius: BorderRadius.circular(10),
                    loading: authController.isLoading.value,
                    onPress: (){
                      sendPhoneNumber();
                    },
                    title: 'NEXT'))


              ],
            ),



          ],
        ),
      ),
    );
  }
}
