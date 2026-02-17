import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final Icon prefix;
  final String hintText;
  final Icon? suffix;
  final FocusNode? focusNode;
  const Customtextfield({
    super.key,
    this.focusNode,
    required this.prefix,
    required this.hintText,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        prefixIcon: prefix,
        hintText: hintText,
        suffixIcon: suffix,
        isDense: true,
      ),
    );
  }
}
