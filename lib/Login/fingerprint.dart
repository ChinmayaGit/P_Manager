import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:pdmanager/Global/global.dart';
import 'package:pdmanager/pages/homePage.dart';
import 'package:pinput/pinput.dart';

class FingerprintAuth extends StatefulWidget {
  const FingerprintAuth({Key? key}) : super(key: key);

  @override
  _FingerprintAuthState createState() => _FingerprintAuthState();
}

class _FingerprintAuthState extends State<FingerprintAuth> {
  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate");
    } on PlatformException catch (e) {
      print(e);
    }
    if(authenticated)
    Get.offAll(const HomePage());
    setState(() {
      authorized =
          authenticated ? "Authorized success" : "Failed to authenticate";
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade600,
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   Get.to(HomePage());
      // }),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 50,
              ),
              Lottie.asset('assets/fingerprint.json'),
              Pinput(
                defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                validator: (s) {
                  if(s==box.read('pin')){Get.offAll(const HomePage());}
                  return s == '2222' ? null : 'Pin is incorrect';
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) {
                  // print(pin);
                  // print(box.read('pin')==pin.toString());
                  // if(box.read('pin')==pin){
                  //   Get.to(const HomePage());
                  // }

                  // Get.to(const HomePage());
                },
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                "PIN Code Verification",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansSemiBold'),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "OR",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontFamily: 'WorkSansSemiBold'),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                  onTap: () {
                    authenticate();
                  },
                  child: Image.asset(
                    "assets/fingerprint.png",
                    height: 80,
                    width: 80,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
