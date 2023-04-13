import 'package:flutter/material.dart';
import 'package:get/get.dart';

textFields({
  required String name,
  required String hint,
  required ico,
  controller,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    width: Get.width * 0.8,
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextFormField(
      autofocus: false,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) return 'This field cannot be empty';
        return null;
      },
      // onSaved: (value) =>
      // _nameController = value.toString(),
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        icon: Icon(ico),
        hintText: name,
        labelText: hint,
      ),
    ),
  );
}