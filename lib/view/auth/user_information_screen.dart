import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/auth_controller.dart';
import '../../res/color/app_color.dart';
import '../../res/size_config/size_config.dart';
import '../../utils/utils.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  AuthController authController = Get.put(AuthController());



  void selectImage() async{
    image = await pickImageFromGalley(context);
    setState(() {

    });
  }

  void storeUserData() async {
    String name = authController.nameController.value.text.trim();

    if (name.isNotEmpty) {
      authController.saveUserDataToFirebase(context, name, image,);
      authController.isLoading.value = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: getHeight(30),),
                Stack(
                  children: [
                   image == null?  
                   const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg"
                      ),
                      radius: 64,

                    ): CircleAvatar(
                       radius: 64,
                       backgroundImage: FileImage(image!)

                   ),
                       
                    Positioned(
                      bottom: -10,
                      left: getWidth(80),
                      child: IconButton(
                          onPressed: (){
                            selectImage();
                          },
                          icon: const Icon(Icons.add_a_photo)
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: getWidth(306),
                      padding:  EdgeInsets.symmetric(horizontal: getWidth(20), vertical: getHeight(20)),
                      child: TextField(
                        controller: authController.nameController.value,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),

                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          storeUserData();
                        },
                        icon: authController.isLoading.value? const CircularProgressIndicator(color: AppColor.tabColor,): const Icon(Icons.done),
                    )
                  ],
                )
              ],
            ),
          )
      ),

    );
  }
}
