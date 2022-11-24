import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_app/Service/DataBaseHelper.dart';
import 'package:wallpaper_app/Service/Favourite.dart';
import 'package:wallpaper_app/page/SignInPage.dart';

class SetWallPaper extends StatefulWidget {
  final String id;
  final String title;
  final String database;
  final String sub;
  final String image;
  final int currentIndex;
  const SetWallPaper({Key? key,required this.id,required this.image,required this.title,required this.database,required this.currentIndex,required this.sub}) : super(key: key);

  @override
  State<SetWallPaper> createState() => _SetWallPaperState();
}

class _SetWallPaperState extends State<SetWallPaper> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  DatabaseHelper databaseHelper=DatabaseHelper();
  bool spinner=false;



  HashSet<String> selectItem=HashSet();

  String url="";
  late PageController pageController;
  int currentIndex=0;
  int count=0;
  String wallpaper="";
  bool Fav=false;

  String image="";
  StreamSubscription? _streamSubscription;


  void multipleSelection(String title,String image,String type,int index) async{

    if(selectItem.contains(title)){
      FirebaseFirestore.instance.collection("/Fav").doc(title).delete();
      databaseHelper.removeFav(title);
      databaseHelper.fetchFav();

      selectItem.remove(title);


    }
    else{
      FirebaseFirestore.instance.collection("/Fav").doc(title).set({"title":title,"image":image,"type":type});

      databaseHelper.addFav(title,image,type);
      selectItem.add(title);


    }

    setState(() {

    });
  }

  void toastmessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textColor: const Color.fromARGB(255, 0, 0, 0),
        fontSize: 16.0);
  }

  showMessage(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context,setState){
            return  AlertDialog(
              title:  Text("Are you want to watch Ads?",style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 16)),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
                    ),
                    onPressed: (){
                  setState((){

                 //_showRewardedAd();

                    /*EasyAds.instance.onEvent.listen((event) {
                     Future.delayed(const Duration(seconds: 2),() =>  Fluttertoast.showToast(msg: "Please wait ads will be loading ..."));
                    });*/
                    if (EasyAds.instance.isInterstitialAdLoaded() || EasyAds.instance.isRewardedAdLoaded()) {
                      // Canceling the last callback subscribed
                      spinner=true;
                      _streamSubscription?.cancel();
                      // Listening to the callback from showInterstitialAd()
                      _streamSubscription =
                          EasyAds.instance.onEvent.listen((event) {
                            if (event.adUnitType == AdUnitType.interstitial || event.adUnitType == AdUnitType.rewarded &&
                                event.type == AdEventType.adDismissed) {
                              _streamSubscription?.cancel().then((value){
                                Navigator.pop(context);
                                showAlert(context, image);
                              });
                              print("Ads Close");
                              spinner=false;

                            }

                          });

                      //Navigator.pop(context);

                    }
                    else{
                      spinner=false;
                      Fluttertoast.showToast(msg: "Failed to load Ads");
                      Navigator.pop(context);
                    }

                    EasyAds.instance.showAd(AdUnitType.interstitial);
                    EasyAds.instance.showAd(AdUnitType.rewarded);










                  });




                }, child: Text("Watch Ads")),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
                    ),
                    onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("Skip")),
              ],
            );
          },

        );
      },
    );
  }
  showAlert(BuildContext context,String image){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal:80,vertical: 40),
            title: const Text("Set Wallpaper"),
            content: Column(

              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width:300,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10))
                      ),
                      onPressed: (){

                        setState((){
                          /*WallpaperManager.clearWallpaper();*/
                          save(image, WallpaperManager.HOME_SCREEN);
                        });

                        Navigator.pop(context);
                      }, child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 5),
                      Icon(Icons.home_filled),
                      SizedBox(width: 5),
                      Text("Home Screen"),
                      SizedBox(width: 5),
                    ],
                  )),
                ),
                SizedBox(height: 10),

                SizedBox(
                  width:300,
                  child: ElevatedButton(

                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10))
                      ),
                      onPressed: (){

                        setState((){
                          /*WallpaperManager.clearWallpaper();*/
                          save(image, WallpaperManager.LOCK_SCREEN);
                        });

                        Navigator.pop(context);
                      }, child:  Row(

                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 5),
                      Icon(Icons.lock),
                      SizedBox(width: 5),
                      Text("Lock Screen"),
                      SizedBox(width: 5),
                    ],
                  )),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      style: ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10))
                      ),
                      onPressed: (){

                        setState((){
                          /*WallpaperManager.clearWallpaper();*/
                          save(image, WallpaperManager.BOTH_SCREEN);
                        });

                        Navigator.pop(context);
                      }, child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 5),
                      Icon(Icons.mode_standby_outlined),
                      SizedBox(width: 5),
                      Text("Both Screen"),
                      SizedBox(width: 5),
                    ],
                  )),
                ),


              ],
            ),
          );
        });
  }
  save(String image,int location) async {
    String resulterr="";

    var file = await DefaultCacheManager().getSingleFile(image);

    print("File "+file.absolute.path);
    try {
     /* var res=await Dio().download(image,file.path);*/

      //ImageGallerySaver.saveImage(res.data);
      await WallpaperManager.setWallpaperFromFile(file.path,location).then((value){

        FirebaseFirestore.instance.collection("/Wallpaper-Download").doc(widget.title).set(
            {
              "id":FirebaseAuth.instance.currentUser?.uid,
              "title":widget.title,
              "image":image,
              "count":count,
              "type":"free",
            }).then((value){
          toastmessage("Wallpaper set Successfully");

        });
      });
      count++;
      print("Result $resulterr");
    } on PlatformException {
      resulterr = 'Failed to get wallpaper.';
      debugPrint(resulterr);
    }



  }
  String fav="";
   getStoragePermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      setState(() {});
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {});
    }
  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
/*liveWallPaper() async{
    var file=await DefaultCacheManager().getSingleFile(image);
    print(file);
  return await AsyncWallpaper.setLiveWallpaper(filePath:file.absolute.path,goToHome: true);
}*/
  String androidId="";
late bool flag;
  String banner="";
  String reward="";
  String interstitialId="";
startAds() async{

   FirebaseFirestore.instance.collection("/Ads").doc("/data").snapshots().listen((value){
    setState(() {
      banner=value["banner"];
      reward=value["reward"];
      interstitialId=value["interstitialId"];
      //Fluttertoast.showToast(msg: "banner"+ banner);



    });

  });
  //SharedPreferences preferences=await SharedPreferences.getInstance();
  //data=preferences.getString("key").toString();
  print("banner"+banner);
  print(reward);
  print(interstitialId);

}
  final CacheManager cacheManager=CacheManager(Config('custom',maxNrOfCacheObjects: 1000,stalePeriod:const Duration(days: 6)));
  @override
  void initState() {

    EasyAds.instance.loadAd();
    databaseHelper.init();


    getStoragePermission();
    /*FirebaseFirestore.instance.collection("/Ads").doc("/data").snapshots().listen((value){
      androidId=value["appId"];
      Fluttertoast.showToast(msg: androidId);
    });*/



    pageController=PageController(initialPage: widget.currentIndex);
    databaseHelper.fetchFav().then((value) {
      value.map((e) => selectItem.add(e.title)).toList();

    });
    setState(() {
      flag=false;
      firestore.collection("/Fav").doc(FirebaseAuth.instance.currentUser?.uid).collection("/like").where("Fav",isEqualTo: true).get().then((value){
        if(mounted){
          setState(() {
            value.docs.map((e) => selectItem.add(e["title"])).toList();
          });
        }
      });

      secureScreen();
    });


    currentIndex=widget.currentIndex;
    image=widget.image;
    super.initState();

  }

  String premium="";
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white),onPressed:(){
          Navigator.pop(context);
        }),
        title: Text("Set WallPaper",style: TextStyle(color: Colors.white)),
      ),

      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: widget.sub.toString().isNotEmpty?
            StreamBuilder(
                stream: firestore.collection(widget.database).doc(FirebaseAuth.instance.currentUser?.uid).collection(widget.sub.toString()).snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){

          if(snapshot.hasData){
        secureScreen();
        print("current"+widget.currentIndex.toString());

        print("Next Image"+image);


        return PageView.builder(
            controller: pageController,
            onPageChanged: (index){

              print("image $image");
              setState(() {

                secureScreen();
                currentIndex=index;



                image=snapshot.data!.docs[index]["image"];




              });
            },
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:snapshot.data?.docs.length,
            itemBuilder: (context,index){
              //Fluttertoast.showToast(msg: snapshot.data?.docs[index]["type"]);
              //Fluttertoast.showToast(msg: snapshot.data?.docs[index]["type"]);



              if(widget.database=="/premium" || widget.database=="/Fav"){

                premium=snapshot.data?.docs[index]["type"]=="premium"?"premium":"free";



              }


              return Hero(
                  tag: widget.currentIndex,
                  child:CachedNetworkImage(
                    placeholder: (context,string)=>Center(child: CircularProgressIndicator()),


                    imageUrl: snapshot.data?.docs[index]["image"],
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(snapshot.data?.docs[index]["image"]),
                            fit: BoxFit.cover,
                           ),
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 80,right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Card(

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                      color: Colors.pinkAccent.shade400,
                                      child: IconButton(icon:Icon(selectItem.contains(snapshot.data?.docs[index]["title"])?Icons.favorite:Icons.favorite_border),color: Colors.white,onPressed: (){
                                        setState(() {
                                          if(widget.database=="/premium"){
                                            premium=snapshot.data?.docs[index]["type"]=="premium"?"premium":"free";
                                            multipleSelection(snapshot.data?.docs[index]["title"],snapshot.data?.docs[index]["image"],premium,index);
                                          }
                                          else{
                                            multipleSelection(snapshot.data?.docs[index]["title"],snapshot.data?.docs[index]["image"],"free",index);
                                          }

                                        });
                                      })),
                                ),
                                premium=="premium"?Visibility(
                                  visible: flag,
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: InkWell(
                                      onTap: (){
                                        print(widget.database);
                                        if(FirebaseAuth.instance.currentUser?.uid!=null){
                                          FlutterShare.share(title: snapshot.data!.docs[index]["title"], linkUrl: snapshot.data!.docs[index]["image"]).then((value){
                                            firestore.collection("/Share").doc().set({
                                              "title":snapshot.data!.docs[index]["title"],
                                              "image":snapshot.data!.docs[index]["image"],
                                            });
                                            Fluttertoast.showToast(msg: "Successfully share ${snapshot.data!.docs[index]["title"]} wallpaper");
                                          });
                                        }
                                        else{
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                                        }
                                      },
                                      child: Card(

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          elevation: 5,
                                          color: Colors.red.shade400,
                                          child: Center(
                                              child: Icon(Icons.share_outlined,
                                                  size: 20, color: Colors.white))),
                                    ),
                                  ),
                                ):SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: InkWell(
                                    onTap: (){
                                      print(widget.database);
                                      if(FirebaseAuth.instance.currentUser?.uid==null){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                                      }
                                      else{
                                        FlutterShare.share(title: snapshot.data!.docs[index]["title"], linkUrl: snapshot.data!.docs[index]["image"]).then((value){
                                          firestore.collection("/Share").doc().set({
                                            "title":snapshot.data!.docs[index]["title"],
                                            "image":snapshot.data!.docs[index]["image"],
                                          });
                                          Fluttertoast.showToast(msg: "Successfully share ${snapshot.data!.docs[index]["title"]} wallpaper");
                                        });
                                      }
                                    },
                                    child: Card(

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 5,
                                        color: Colors.red.shade400,
                                        child: Center(
                                            child: Icon(Icons.share_outlined,
                                                size: 20, color: Colors.white))),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: InkWell(
                                    onTap: () async{
                                      /*var response = await Dio().get(image,
                                        options: Options(responseType: ResponseType.bytes));*/


                                     if(FirebaseAuth.instance.currentUser?.uid==null){
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                                     }else{
                                       await ImageGallerySaver.saveImage(snapshot.data?.docs[index]["image"]);
                                       setState(() {
                                         premium=="premium"?Container():firestore.collection("/most-popular").doc(FirebaseAuth.instance.currentUser?.uid).collection("/popular").doc(snapshot.data!.docs[index]["title"]).set(
                                             {
                                               "id":FirebaseAuth.instance.currentUser?.uid,
                                               "title":widget.title,
                                               "image":image,
                                               "count":count,
                                               "type":"free",
                                             }).then((value) =>  Fluttertoast.showToast(msg: "WallPaper Download Successfully"));

                                       });
                                     }
                                    },
                                    child: Card(

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 5,
                                        color: Colors.green.shade400,
                                        child: Center(
                                            child: Icon(Icons.download_for_offline_sharp,
                                                size: 20, color: Colors.white))),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    errorWidget: (context, url, error) => Icon(Icons.error),


                  ));
            });
    }
    return const Center(child: CircularProgressIndicator());
  })
            :widget.database=="/Fav"?FutureBuilder<List<Favourite>>(
            future: databaseHelper.fetchFav(),
            builder: (context,snapshot){

              if(snapshot.hasData){
                secureScreen();
                /* print("current"+widget.currentIndex.toString());*/
                /*image=snapshot.data![widget.currentIndex].image;*/
                print("Next Image"+image);


                return PageView.builder(
                    controller: pageController,
                    onPageChanged: (index){

                      print("image $image");
                      setState(() {
                        secureScreen();
                        flag=false;
                        currentIndex=index;

                        image=snapshot.data![index].image;



                      });
                    },
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount:snapshot.data?.length,
                    itemBuilder: (context,index){
                      if(widget.database=="/Fav"){
                        premium=snapshot.data?[index].type=="premium"?"premium":"free";
                      }
                      /* print(snapshot.data!.docs[index]["type"]);

                  print(snapshot.data!.docs[index]["image"]);*/

                      return Hero(
                          tag: widget.currentIndex,
                          child:
                          CachedNetworkImage(

                            imageUrl: snapshot.data![index].image,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:  NetworkImage(snapshot.data![index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 80,right: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Card(

                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              elevation: 5,
                                              color: Colors.pinkAccent.shade400,
                                              child: IconButton(icon:Icon(selectItem.contains(snapshot.data?[index].title)?Icons.favorite:Icons.favorite_border),color: Colors.white,onPressed: (){
                                                setState(() {
                                                  if(widget.database=="/premium"){
                                                    premium=snapshot.data?[index].type=="premium"?"premium":"free";

                                                    multipleSelection(snapshot.data![index].title,snapshot.data![index].image,premium,index);
                                                  }
                                                  else{

                                                    multipleSelection(snapshot.data![index].title,snapshot.data![index].image,"free",index);
                                                  }

                                                });
                                              })),
                                        ),
                                        snapshot.data?[index].type=="premium"?
                                        Container():SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: InkWell(
                                            onTap: (){
                                              print(widget.database);
                                              if(FirebaseAuth.instance.currentUser?.uid==null){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                                              }
                                              else{
                                                FlutterShare.share(title: snapshot.data![index].title, linkUrl: snapshot.data![index].image).then((value){
                                                  firestore.collection("/Share").doc().set({
                                                    "title":snapshot.data?[index].title,
                                                    "image":snapshot.data?[index].image,
                                                  });
                                                  Fluttertoast.showToast(msg: "Successfully share ${snapshot.data?[index].title} wallpaper");
                                                });
                                              }
                                            },
                                            child: Card(

                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 5,
                                                color: Colors.red.shade400,
                                                child: Center(
                                                    child: Icon(Icons.share_outlined,
                                                        size: 20, color: Colors.white))),
                                          ),
                                        ),
                                        snapshot.data?[index].type=="premium"?
                                        Container():SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: InkWell(
                                            onTap: () async{

                                              if(FirebaseAuth.instance.currentUser?.uid==null){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                                              }
                                              else{

                                                var response = await Dio().get(image,
                                                    options: Options(responseType: ResponseType.bytes));

                                                ImageGallerySaver.saveImage(response.data);
                                                print(image);
                                                setState(() {
                                                  premium=="premium"?Container():firestore.collection("/most-popular").doc(FirebaseAuth.instance.currentUser?.uid).collection("/popular").doc(snapshot.data?[index].title).set(
                                                      {
                                                        "id":FirebaseAuth.instance.currentUser?.uid,
                                                        "title":widget.title,
                                                        "image":image,
                                                        "count":count,
                                                        "type":"free",
                                                      }).then((value) =>  Fluttertoast.showToast(msg: "WallPaper Download Successfully"));

                                                });
                                                }
                                              },
                                            child: Card(

                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 5,
                                                color: Colors.green.shade400,
                                                child: Center(
                                                    child: Icon(Icons.download_for_offline_sharp,
                                                        size: 20, color: Colors.white))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }):StreamBuilder(
            stream: widget.database=="/category"?firestore.collection("/category").doc(widget.id).collection("/data").snapshots():firestore.collection(widget.database).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
             /* Fluttertoast.showToast(msg:currentIndex.toString()+ "and $image");*/
              if(snapshot.hasData){
                secureScreen();

               /* print("current"+widget.currentIndex.toString());*/

                print("Next Image"+image);


                return PageView.builder(
                    controller: pageController,
                    onPageChanged: (index){

                      print("image $image");
                      setState(() {
                        secureScreen();
                        flag=false;
                        currentIndex=index;


                        image=snapshot.data!.docs[index]["image"];



                      });
                    },
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount:snapshot.data?.docs.length,
                    itemBuilder: (context,index){




                      if(widget.database=="/premium" || widget.database=="/category"){

                         premium=snapshot.data?.docs[index]["type"]=="premium"?"premium":"free";


                      }


                      return Hero(
                          tag: widget.currentIndex,
                          child:
                          CachedNetworkImage(


                            imageUrl: snapshot.data!.docs[index]["image"],
                            imageBuilder: (context, imageProvider) =>
                                Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(snapshot.data!.docs[index]["image"]),
                                    fit: BoxFit.cover,
                                ),
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 80,right: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Card(

                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              elevation: 5,
                                              color: Colors.pinkAccent.shade400,
                                              child: IconButton(icon:Icon(selectItem.contains(snapshot.data?.docs[index]["title"])?Icons.favorite:Icons.favorite_border),color: Colors.white,onPressed: (){
                                                setState(() {

                                                    premium=snapshot.data?.docs[index]["type"]=="premium"?"premium":"free";
                                                    multipleSelection(snapshot.data?.docs[index]["title"],snapshot.data?.docs[index]["image"],premium,index);


                                                });
                                              })),
                                        ),
                                        premium=="premium"?Container():SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: InkWell(
                                            onTap: (){
                                              print(widget.database);
                                              if(FirebaseAuth.instance.currentUser?.uid==null){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                                              }
                                              else{
                                                FlutterShare.share(title: snapshot.data!.docs[index]["title"], linkUrl: snapshot.data!.docs[index]["image"]).then((value){
                                                  firestore.collection("/Share").doc().set({
                                                    "title":snapshot.data!.docs[index]["title"],
                                                    "image":snapshot.data!.docs[index]["image"],
                                                  });
                                                  Fluttertoast.showToast(msg: "Successfully share ${snapshot.data!.docs[index]["title"]} wallpaper");
                                                });
                                              }
                                            },
                                            child: Card(

                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 5,
                                                color: Colors.red.shade400,
                                                child: Center(
                                                    child: Icon(Icons.share_outlined,
                                                        size: 20, color: Colors.white))),
                                          ),
                                        ),
                                        snapshot.data!.docs[index]["type"]=="premium"?
                                        Container():SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: InkWell(
                                            onTap: () async{


                                             if(FirebaseAuth.instance.currentUser?.uid!=null){
                                               var response = await Dio().get(image,
                                                   options: Options(responseType: ResponseType.bytes));



                                               premium=="premium"?null: await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
                                               setState(() {
                                                 premium=="premium"?Container():firestore.collection("/most-popular").doc(FirebaseAuth.instance.currentUser?.uid).collection("/popular").doc(snapshot.data!.docs[index]["title"]).set(
                                                     {
                                                       "id":FirebaseAuth.instance.currentUser?.uid,
                                                       "title":widget.title,
                                                       "image":image,
                                                       "count":count,
                                                       "type":"premium",
                                                     }).then((value) {

                                                   Fluttertoast.showToast(msg: "WallPaper Download Successfully");});

                                               });
                                             }
                                             else{
                                               Navigator.push(context,MaterialPageRoute(builder: (context)=>SignInPage()));
                                             }
                                            },
                                            child: Card(

                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 5,
                                                color: Colors.green.shade400,
                                                child: Center(
                                                    child: Icon(Icons.download_for_offline_sharp,
                                                        size: 20, color: Colors.white))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const EasyBannerAd(
              adNetwork: AdNetwork.admob, adSize: AdSize.banner),
          FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple,
            heroTag: "id",
            extendedPadding: EdgeInsets.symmetric(horizontal: 100),
            onPressed: () async{

              setState(() {


                premium=="premium"?showMessage(context)/*widget.database=="/live-wallpaper"?liveWallPaper()*/:showAlert(context,image);

              });





              print(widget.id);



            }, label:const Text("Set WallPaper",style: TextStyle(color: Colors.white)),
          ),

        ],
      ),

    );
  }
}
