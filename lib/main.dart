import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_app/res/color/app_color.dart';
import 'package:whatsapp_app/res/routes/routes.dart';
import 'controller/message_reply_controller/message_reply_controller.dart';
import 'data/Model/user_model.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserModel(
    name: 'John Doe',
    uid: '12345',
    profilePic: 'url/to/profilePic',
    isOnline: true,
    phoneNumber: '123-456-7890',
    groupId: ['group1', 'group2'],

  ));
  Get.put(MessageReplyController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp App',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor:AppColor.backgroundColor,
          appBarTheme: const AppBarTheme(
              color: AppColor.appBarColor
          )
      ),
     getPages: AppRoutes.appRoutes(),
     // home: const MobileLayoutScreen(),


    );
  }
}
