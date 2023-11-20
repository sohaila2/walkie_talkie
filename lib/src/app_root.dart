import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/register_view.dart';
import '../views/signin_view.dart';
import '../views/recordings_view.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeView.id,
      routes: {
        HomeView.id : (context)=> HomeView(),
        RegisterView.id : (context)=> RegisterView(),
        SigninView.id : (context)=> SigninView(),
        RecordingsView.id : (context)=> RecordingsView(),

      },
    );
  }
}
