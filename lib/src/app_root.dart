import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walkie_talkie/screens/login_screen.dart';
import 'package:walkie_talkie/screens/register_screen.dart';
import 'package:walkie_talkie/screens/walkie_screen.dart';

import '../constants.dart';
import '../cubits/login/login_cubit.dart';
import '../cubits/register/register_cubit.dart';
import '../cubits/walkie/walkie_cubit.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
       BlocProvider(create: (context) => WalkieCubit()),


      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: kColourPrimary,
          scaffoldBackgroundColor: kColourBackground,
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: kColourPrimary,
          ),
        ),

        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          WalkieScreen.id: (context) => WalkieScreen(),
        },
        initialRoute: LoginScreen.id,
      ),
    );
  }
}
