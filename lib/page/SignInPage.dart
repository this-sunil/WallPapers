
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/page/MainScreen.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;


    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      print("firebase"+credential.token.toString());

      SharedPreferences preferences=await SharedPreferences.getInstance();
      await auth.signInWithCredential(credential).then((value) {

      });

      preferences.setString("key", googleSignInAuthentication.accessToken.toString());
      FirebaseFirestore.instance.collection("/register").doc(auth.currentUser?.uid).set({
        "username":googleSignIn.currentUser?.displayName,
        "email":googleSignIn.currentUser?.email,
        "photoUrl":googleSignIn.currentUser?.photoUrl,

      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
      print("${googleSignIn.currentUser!.displayName}");
    }
  }
    @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
                    }, child: Text("Skip",style: TextStyle(color: Colors.white),)),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Lottie.asset(
                          'assets/user-profile.json',

                        ),
                      ),
                      SizedBox(height: 20),
                      SignInButton(
                          Buttons.Google,
                          elevation: 10,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          /*style: ButtonStyle(
                            elevation: MaterialStateProperty.all(10),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 100,vertical: 10)),
                            backgroundColor: MaterialStateProperty.all(Colors.white),

                          ),*/
                          onPressed: (){
                          signInWithGoogle(context: context);
                          }, text: "Sign In with Google"),

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
