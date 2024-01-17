import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:flutter/material.dart';

// Global object for getting screen size
late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       appBarTheme: AppBarTheme(
         backgroundColor: Colors.white,
         centerTitle: true,
         elevation: 1,
           titleTextStyle: TextStyle(color: Colors.black, fontSize: 19),
         ),
       ),

      home: LoginScreen(),
    );
  }
}
