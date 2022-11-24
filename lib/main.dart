// ignore_for_file: prefer_const_literals_to_create_immutables


import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/Service/NotificationCounter.dart';
import 'package:wallpaper_app/page/MainScreen.dart';
import 'package:wallpaper_app/page/Notification.dart';
import 'package:wallpaper_app/Service/CustomNotification.dart';
import 'package:wallpaper_app/page/SplashScreen.dart';

import 'Service/TestAdIdManager.dart';


var data;
bool flag=false;

Future<void> backgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
    debugPrint("Remote Message:${message.data}");

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);






    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    CustomNotification().init();


  });
  SharedPreferences preferences=await SharedPreferences.getInstance();
  data=preferences.getString("user").toString();
  FirebaseFirestore.instance.collection("/Ads").doc("/data").snapshots().listen((value){


    //Fluttertoast.showToast(msg: "banner"+ banner);


      IAdIdManager adIdManager=TestAdIdManager(banner: value["banner"],interstitialId: value["interstitialId"],reward: value["reward"]);
      EasyAds.instance.initialize(
        adIdManager,
        unityTestMode: false,
        adMobAdRequest: const AdRequest(),
        /*admobConfiguration: RequestConfiguration(
        testDeviceIds: ["5E7A9A28137474CC7261BEC17B19E4AB"],
      ),*/
      );



  });
  CustomNotification().init();

  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  fetchData(){

      if(data=="null"){
        flag=false;
        print("Token of sharedPreferences $flag");

      }
      else{
        flag=true;
        print("Coming started data with main $data");
      }



  }
  @override
  void initState() {

    fetchData();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        setState(() {
          backgroundHandler(message);
        });
      }
    });

    //CustomNotification().createNotification("Hi Bro","welcome Liberty Paint");
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("${event.notification!.title}");
      print("${event.notification!.body}");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NotificationDetails()));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message token");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        CustomNotification().createNotification(
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            message.notification!.android!.imageUrl.toString());

        //print(message.notification!.android!.count);
        firebaseMessaging.getToken().then((token) {
          print("Device Token: $token");
          FirebaseFirestore.instance.collection("/Notification").doc().set({
            "id":FirebaseAuth.instance.currentUser!.uid,
            "title": message.notification!.title,
            "message": message.notification!.body,
            "device_token":token,
            "image": message.notification!.android!.imageUrl,
          });
        });
      }
    });
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    CustomNotification().display();
    super.initState();
  }
  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    //print(flag);
    return ChangeNotifierProvider<NotificationCounters>(
        create: (_)=> NotificationCounters(0),

        child: MaterialApp(

          /*theme: themeNotifier.getTheme(),*/
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          debugShowCheckedModeBanner: false,
          title: "Daily Full HD Wallpaper",
          home:data=="null"?SplashScreen():MainScreen(),


        ),

    );
  }
}
