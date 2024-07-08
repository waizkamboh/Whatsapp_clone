import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../view/landing/landing_screen.dart';
import '../../view/mobile_layout/mobile_layout_screen.dart';


class SplashServices{


  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user != null){
      Timer(const Duration(seconds: 3),
              () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MobileLayoutScreen())));


    }else{
      Timer(const Duration(seconds: 3),
              () => Navigator.push(context, MaterialPageRoute(builder: (context) =>   LandingScreen())));

    }


  }
}