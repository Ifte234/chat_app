// import 'package:chat_app/Screens/HomePage.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../HomePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isanimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isanimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Login "),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * 0.15,
              left: _isanimate ? mq.width * 0.25 : -mq.width * 0.5,
              width: mq.width * 0.5,
              child: Image.asset('images/icon.png'),
              duration: Duration(seconds: 10)),

          // ********************Google Login *****************************
          Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * 0.05,
              width: mq.width * 0.9,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                icon: Image.asset(
                  'images/google.png',
                  height: mq.height * 0.05,
                ),
                label: Text(
                  'Signin with Google',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                // icon:
              )),
        ],
      ),
    );
  }
}
