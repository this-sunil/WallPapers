import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpaper_app/page/MainScreen.dart';
import 'package:wallpaper_app/page/SignInPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController animationController;


  @override
  void initState() {
    final user = _auth.currentUser;
    animationController=AnimationController(vsync: this,lowerBound: 10,upperBound: 10);
    if (user != null) {
      Timer(Duration(seconds: 1), (() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()))));
    } else {
      print("sign up");
      Timer(
          Duration(seconds: 1), (() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()))));
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
          children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/most.jpg"

              ),
            )
          ),
        ),

       Center(
          child: AnimatedContainer(
            height: 200,
            width: 200,
            duration: Duration(seconds: 5),
            curve: Curves.bounceIn,
            child: CircleAvatar(
                maxRadius: animationController.lowerBound*animationController.upperBound,
                backgroundImage: AssetImage("assets/logo.png")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: const Align(
             alignment: Alignment.bottomCenter,
              child: AnimatedDefaultTextStyle(child: Text("Daily Full HD WallPaper"),

                  curve: Curves.bounceIn,
                  style: TextStyle(fontSize: 18,color: Colors.white), duration: Duration(seconds: 10))),
        ),

      ]),
    );
  }
}