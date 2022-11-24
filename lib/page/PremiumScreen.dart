import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';

class PremiumScreen extends StatefulWidget {

  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<void> secureScreen() async {

    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  @override
  void initState() {
    secureScreen();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
        stream: firestore.collection("/premium").where("type",isEqualTo: "premium").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return MasonryGridView.count(
                crossAxisCount: 3,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context,index){
                  return
                    InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SetWallPaper(id: "", title:  snapshot.data?.docs[index]["title"], database: "/premium", currentIndex: index, sub: '',image: snapshot.data?.docs[index]["image"])));
                      },
                      child: Hero(
                      tag: "$index",
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,

                                image: NetworkImage("${snapshot.data?.docs[index]["image"]}"),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:  snapshot.data?.docs[index]["type"]=="free"?Container():Banner(
                                  color: Colors.pinkAccent,

                                  message: "${snapshot.data?.docs[index]["type"]}", location: BannerLocation.topEnd),
                            ),
                          ),
                        ),
                      ),
                  ),
                    );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
