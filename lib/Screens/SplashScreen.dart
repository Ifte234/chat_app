import 'package:chat_app/Screens/HomePage.dart';
import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      if(FirebaseAuth.instance.currentUser != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomePage()));
      }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/icon.png"),
          Text("Made in Flutter by Ift",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
