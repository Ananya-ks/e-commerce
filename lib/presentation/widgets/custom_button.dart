import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  final Color buttonColor; 
  final Color fontColor;
  MyButton({super.key, required this.onPressed, required this.buttonName, required this.buttonColor, required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor, foregroundColor: fontColor),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
