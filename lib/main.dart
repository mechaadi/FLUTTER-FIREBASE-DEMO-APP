import 'package:flutter/material.dart';
import 'package:social_test_app/pages/mainpage.dart';
import 'package:social_test_app/pages/signin_screen.dart';
import 'package:social_test_app/pages/splash_screen.dart';

//void main() => runApp(MyApp());

void main() async {
  runApp(MaterialApp(
   
    routes: <String, WidgetBuilder>{
      '/':(context)=>Mainpage(),
      '/signIn':(context)=>SigninScreen(),
      '/splash':(context)=>SplashScreen(),
    },
    theme: ThemeData.dark(),
    initialRoute: '/splash',
    title: 'SOCIAL MEDIA TEST APPLICATION',
  ));
}


