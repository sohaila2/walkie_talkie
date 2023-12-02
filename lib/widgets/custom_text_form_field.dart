

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({super.key,this.hintText,this.onChanged,this.obscureText = false});

  String? hintText;
  Function(String)? onChanged;
  bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data){
        if(data!.isEmpty){
          return 'field is required';
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.black45
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black54
            )
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black54
            )
        ),
      ),
    );
  }


}
