import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/page/PremiumScreen.dart';
import 'package:wallpaper_app/Service/WallPaperSearch.dart';
import 'package:wallpaper_app/page/CategoryScreen.dart';
import 'package:wallpaper_app/page/DownloadWallpaperScreen.dart';
import 'package:wallpaper_app/page/FavouritePage.dart';
import 'package:wallpaper_app/page/MostPopularScreen.dart';
import 'package:wallpaper_app/page/Notification.dart';
import 'package:wallpaper_app/page/PrivacyPolicyScreen.dart';
import 'package:wallpaper_app/page/SignInPage.dart';
import 'package:wallpaper_app/page/TrendingScreen.dart';
import 'package:flutter_share/flutter_share.dart';
class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  late TabController tabController;
  int  counter=0;
  /*late BannerAd _bannerAd;*/
  late SharedPreferences pref;

  bool isLoaded=false;
  /*InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;*/

  String Email="";
  String username="";
  String photo="";
  String photoUrl="";
  FirebaseAuth auth=FirebaseAuth.instance;

  FirebaseFirestore firestore=FirebaseFirestore.instance;

  DateTime? backButtonPressTime;
  final snackBar = const SnackBar(
    content: Text('Press back again to leave'),
    duration: Duration(seconds: 3),
  );
  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }


  /*initBannerAd() async{
    _bannerAd=BannerAd(size: AdSize.banner, adUnitId:BannerAd.testAdUnitId, listener: BannerAdListener(
      onAdLoaded: (ad){
        setState(() {
          isLoaded=true;
        });
      },
      onAdClicked: (ad){},
      onAdClosed: (ad){},

      onAdFailedToLoad: (ad,err){},
    ), request: const AdRequest());
   _bannerAd.load();
  }*/
  fetchUserData() async{
    pref=await SharedPreferences.getInstance();
    //print(pref.setString("data",key).then((value) => value));
  }
  @override
  void initState() {
    fetchUserData();
    tabController=TabController(length: 4, vsync: this);
    //fetchUserData();
    setState(() {

     // initBannerAd();
      if(auth.currentUser!=null){
        /*username=auth.currentUser!.displayName??"";
        Email=auth.currentUser!.email ?? "";*/
        FirebaseFirestore.instance.collection("/register").doc(auth.currentUser?.uid).get().then((value){
         setState(() {
           username=value["username"];

           pref.setString("user",username).toString();
           Email=value["email"];
           photoUrl=value["photoUrl"];
         });
          print(value["username"]);
        });
        photo=auth.currentUser!.photoURL ?? "";
        print("$photo $username $Email");
      }
    });


    super.initState();
  }
  @override
  void dispose() {

    super.dispose();
  }





  Future<void> share() async {
    await FlutterShare.share(
        title: 'Daily Full HD WallPaper',
        text: '',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.mt.wallpaper_app',
        chooserTitle: '');
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => handleWillPop(context),
      child: Scaffold(
        appBar: AppBar(

          title: const Text("Daily Full HD Wallpapers"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              /*title: tabController.index==0?"category":tabController.index==1?"trending-images":tabController.index==2?"Wallpaper-Download":tabController.index==3?"premium":"live-wallpaper"*/
              showSearch(context: context, delegate: WallPaperSearch());
             // Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen()));
            }, icon: Icon(Icons.search)),
          ],

          bottom: TabBar(
            padding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
              controller: tabController,

              indicatorColor: Colors.white,


              physics: BouncingScrollPhysics(),
              tabs: [
                Tab(
                  child: Text("Category"),
                ),
                Tab(
                  child: Text("Trending"),
                ),
                Tab(
                  child: Text("Most Popular"),
                ),
                Tab(
                  child: Text("Premium"),
                ),
               /* Tab(
                  child: Text("Live WallPaper"),
                ),*/
              ]),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text("$username"),
                  accountEmail: Text("$Email"),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                     image: AssetImage("assets/most.jpg"),
                  ),
                ),
                currentAccountPicture:photoUrl.isEmpty?const CircleAvatar(
                  backgroundImage: AssetImage("assets/brand-logo.png"),
                ):CircleAvatar(backgroundImage: NetworkImage(photoUrl)),

                otherAccountsPictures: [
                  FirebaseAuth.instance.currentUser==null?InkWell(
                     onTap: (){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignInPage()));
                     },
                     child:Card(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                         elevation: 5,
                         color: Colors.deepOrange.shade400,
                         child: Center(child: Icon(Icons.login,size: 14,color: Colors.white))

                     ),):Container(),
                ],

              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const FavouritePage()));
                },
                leading:  SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    color: Colors.pinkAccent.shade400,
                    child: Center(child: Icon(Icons.favorite_border,size: 14,color: Colors.white))

                  ),
                ),
                title: Text("Like Wallpaper",style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,
                ))),
              ),

              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetails()));
                },
                leading:  SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      color: Colors.green.shade400,
                      child: Center(child: Icon(Icons.notifications_none_outlined,size: 14,color: Colors.white))

                  ),
                ),
                title: Text("Notification",style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,
                ))),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
                },
                leading:  SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      color: Colors.pinkAccent,
                      child: Center(child: Icon(Icons.privacy_tip_outlined,size: 14,color: Colors.white))

                  ),
                ),
                title: Text("Privacy Policy",style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,
                ))),
              ),
              ListTile(
                onTap: (){
                  share();
                },
                leading:  SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      color: Colors.orange.shade400,
                      child: Center(child: Icon(Icons.share_outlined,size: 14,color: Colors.white))

                  ),
                ),
                title: Text("Share",style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,
                ))),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DownloadWallpaperScreen()));
                },
                leading:  SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      color: Colors.indigo.shade400,
                      child: Center(child: Icon(Icons.download_for_offline,size: 14,color: Colors.white))

                  ),
                ),
                title: Text("Download Wallpaper",style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,
                ))),
              ),
              Divider(),
              FirebaseAuth.instance.currentUser==null?Container():ListTile(
                onTap: () async{
                  SharedPreferences pref=await SharedPreferences.getInstance();
                  //pref.remove("key").then((value) => Fluttertoast.showToast(msg: '"remove"+$value'));
                  firestore.collection("/register").doc(auth.currentUser?.uid).delete();
                  auth.signOut().then((value){
                    pref.remove("key");
                    GoogleSignIn().signOut();
                    pref.remove("key");

                    Fluttertoast.showToast(msg: "Log out Successfully");
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                },
                leading:  SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      color: Colors.lightBlue.shade400,
                      child: Center(child: Icon(Icons.logout_outlined,size: 14,color: Colors.white))

                  ),
                ),
                title: Text("Log Out",style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,
                ))),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            CategoryScreen(),
            TrendingScreen(),
            MostPopularScreen(),
            PremiumScreen(),
           /* LiveWallPaper(),*/
          ],
        ),
      /*bottomNavigationBar: isLoaded?Container(
            width:50,
            height:50,
            child: AdWidget(ad: _bannerAd)):Container(),*/
      ),
    );
  }
}
