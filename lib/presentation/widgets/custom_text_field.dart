import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final String obscuringCharacter;
  final IconData prefixIconData;
  final Color prefixIconColor;
  final double fontSize;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
    required this.obscuringCharacter,
    required this.prefixIconData,
    required this.prefixIconColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(20.0),
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(
              prefixIconData,
              color: prefixIconColor,
            ),

            /// Text inside the textfield
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            )),

        /// obscureText (bool) -> characters used for hiding the text in textfiled. ex: password dot
        obscureText: obsecureText,
        obscuringCharacter: obscuringCharacter,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
