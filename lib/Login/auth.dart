
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pdmanager/Login/fingerprint.dart';
import 'package:pdmanager/Login/login_page.dart';
import 'package:pdmanager/pages/homePage.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    super.initState();

      Timer(Duration(seconds: 3), () {
        FirebaseAuth.instance
            .authStateChanges()
            .listen((User? user) {
          if (user == null) {
            Get.offAll(Login());
          } else {
            Get.offAll(const FingerprintAuth());
          }
        });
      });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Lottie.asset('assets/loading.json'),
    ],),);
  }
}


