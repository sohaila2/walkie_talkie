import 'package:flutter/material.dart';
import 'package:walkie_talkie/views/register_view.dart';
import 'package:walkie_talkie/views/signin_view.dart';

class HomeView extends StatelessWidget {
  static const String id = 'home_view';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Walkie"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Image.asset("assets/images/walkie.png"),
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SigninView.id);
                  },
                  child: Text('Sign in')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterView.id);
                  },
                  child: Text('Register'))
            ],
          )
        ],
      ),
    );
  }
}
