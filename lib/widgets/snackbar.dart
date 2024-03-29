import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomSnackBar {
  CustomSnackBar({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength:
        Toast.LENGTH_SHORT,
        gravity:
        ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:
        Colors.black12,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
