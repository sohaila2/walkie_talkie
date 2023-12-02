

import 'package:flutter/material.dart';
import 'package:walkie_talkie/constants.dart';

class CustomButton extends StatelessWidget {


  CustomButton({required this.onTap,super.key, required this.text});

  String text;
  VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kColourPrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        height: 60,
        child: Center(
            child: Text(text,style: TextStyle(
              color: Colors.white
            ),)),
      ),
    );
  }
}