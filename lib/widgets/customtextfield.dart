import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final Icon prefix;
  final String hintText;
  final Widget? suffix;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  const Customtextfield({
    super.key,
    this.focusNode,
    required this.prefix,
    required this.hintText,
    this.suffix,
    this.validator,
    this.obscureText = true,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        prefixIcon: prefix,
        hintText: hintText,
        suffixIcon: suffix,
        isDense: true,
      ),
    );
  }
}
