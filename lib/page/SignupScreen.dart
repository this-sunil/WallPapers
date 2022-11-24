// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:wallpaper_app/page/MainScreen.dart';
//
// class Signup extends StatefulWidget {
//   const Signup({Key? key}) : super(key: key);
//
//   @override
//   State<Signup> createState() => _SignupState();
// }
//
// class _SignupState extends State<Signup> {
//   GlobalKey<FormState> formKey=GlobalKey<FormState>();
//   TextEditingController name=TextEditingController();
//   TextEditingController emailAddress=TextEditingController();
//   TextEditingController password=TextEditingController();
//   bool hide=true;
//   FirebaseFirestore firestore=FirebaseFirestore.instance;
//   bool spinner=false;
//   FirebaseAuth auth=FirebaseAuth.instance;
//   void toastmessage(String message) {
//     Fluttertoast.showToast(
//         msg: message.toString(),
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//         textColor: Color.fromARGB(255, 0, 0, 0),
//         fontSize: 16.0);
//   }
//   @override
//   void initState() {
//
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: ModalProgressHUD(
//           inAsyncCall: spinner,
//           child: SingleChildScrollView(
//             child: Form(
//              key: formKey,
//               child: Column(
//
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   SizedBox(height: 50),
//                   SizedBox(
//                     height: 400,
//                     width: double.infinity,
//                     child: Image.asset("assets/signup.png"),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     width: 350,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//
//                           child: TextFormField(
//
//                             cursorColor: Colors.white,
//                             cursorHeight: 22,
//                             textInputAction: TextInputAction.go,
//                             keyboardType: TextInputType.text,
//                             controller: name,
//                             validator: (name)=>name!.isEmpty?"Please Enter your name":null,
//
//
//                             decoration: InputDecoration(
//                               prefixIcon:  Container(
//                                 height: 50,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
//                                   color: Colors.deepPurple,
//                                 ),
//                                 child: Icon(
//                                   Icons.person_add,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               contentPadding: EdgeInsets.all(10),
//                               border:OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               labelText: "Enter your username",
//
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   SizedBox(
//                     width: 350,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//
//                         Expanded(
//
//                           child: TextFormField(
//
//                             controller: emailAddress,
//                             cursorHeight: 22,
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Please enter your mail id";
//                               } else {
//                                 return null;
//                               }
//                             },
//                             decoration: InputDecoration(
//                               prefixIcon:  Container(
//                                 height: 50,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
//                                   color: Colors.deepPurple,
//                                 ),
//                                 child: Icon(
//                                   Icons.email_outlined,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               contentPadding: EdgeInsets.all(10),
//                               border:OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               labelText: "Enter your Email",
//
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   SizedBox(
//                     width: 350,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//
//                         Expanded(
//
//                           child: TextFormField(
//
//                             controller: password,
//                             obscureText: hide,
//                             cursorHeight: 22,
//
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Please enter your password";
//                               } else {
//                                 return null;
//                               }
//                             },
//                             decoration: InputDecoration(
//                               prefixIcon: Container(
//                                 height: 50,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
//                                   color: Colors.deepPurple,
//                                 ),
//                                 child: IconButton(
//                                   onPressed: (){
//                                     setState(() {
//                                       hide=!hide;
//                                     });
//                                   },
//                                   icon:Icon(hide?Icons.visibility_off:Icons.visibility,color: Colors.white),
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               contentPadding: EdgeInsets.all(10),
//                               border:OutlineInputBorder(
//
//                                 borderRadius: BorderRadius.circular(10),
//
//                               ),
//
//                               labelText: "Enter your password",
//
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//
//
//                   SizedBox(
//                     height: 30,
//                   ),
//                   InkWell(
//                     onTap: () async{
//                       if(formKey.currentState!.validate()){
//                         setState(() {
//                           spinner = true;
//                         });
//                        try{
//
//                          await auth.createUserWithEmailAndPassword(email: emailAddress.text, password: password.text).then((value){
//                            if(value.user!=null){
//
//                              firestore.collection("/register").doc(auth.currentUser!.uid).set({
//                                "username":name.text,
//                                "email":emailAddress.text,
//                                "password":password.text,
//                              });
//
//
//
//
//
//                            }
//                            else{
//                              toastmessage("wrong mail id and password"
//                                  "if you don't have account then click on signup button");
//                            }
//                            toastmessage("SignUp Successfully");
//                            setState(() {
//                              spinner = false;
//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
//                            });
//                          });
//                        }
//                        catch(e){
//                          e.toString();
//                          toastmessage(e.toString());
//                          setState(() {
//                            spinner = false;
//                          });
//                        }
//
//                       }
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 200,
//                       child: Center(
//                           child: Text(
//                         "Signup",
//                         style: GoogleFonts.lato(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       )),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.deepPurpleAccent,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
