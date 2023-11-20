import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isSignIn;
  final Function onFormSubmitted;

  const AuthForm(
      {super.key, required this.isSignIn, required this.onFormSubmitted});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  late String email;

  late String password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Walkie'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Image.asset("assets/images/walkie.png"),
              ),
              Text(
                widget.isSignIn ? 'SIGN IN' : 'REGISTER',
                textAlign: TextAlign.center,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: 'Enter your email address'),
                      validator: (String? value) {
                        return value != null && value.contains('@')
                            ? null
                            : 'you are missing an @.';
                      },
                      onChanged: (String? value) {
                        if (value != null) {
                          email = value;
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Enter your password',
                      ),
                      validator: (String? value) {
                        if (value != null && value.length < 6) {
                          return 'Use at least 6 characters!';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        if (value != null) {
                          password = value;
                        }
                      },
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.onFormSubmitted(email, password);
                          }
                        },
                        child: Text(
                          widget.isSignIn ? 'Sign In' : 'Register',
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
