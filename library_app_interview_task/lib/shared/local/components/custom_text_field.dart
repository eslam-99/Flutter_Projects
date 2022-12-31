import 'package:flutter/material.dart';

TextFormField buildTextField({
  required TextEditingController controller,
  required String hintText,
  bool? isObscured,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
    ),
    obscureText: isObscured ?? false,
  );
}
