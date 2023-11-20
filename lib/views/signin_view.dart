import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkie_talkie/views/recordings_view.dart';

import '../components/auth_form.dart';

class SigninView extends StatelessWidget {
  static const String id = 'signin_view';

  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      isSignIn: true,
      onFormSubmitted: (email, password) async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        try {
          final signedInUser =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (signedInUser != null) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, RecordingsView.id);
          }
        } catch (error) {
          Navigator.pop(context);
          print(error);
        }
      },
    );
  }
}
