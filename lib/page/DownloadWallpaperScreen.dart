import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';
class DownloadWallpaperScreen extends StatefulWidget {
  const DownloadWallpaperScreen({Key? key}) : super(key: key);

  @override
  State<DownloadWallpaperScreen> createState() => _DownloadWallpaperScreenState();
}

class _DownloadWallpaperScreenState extends State<DownloadWallpaperScreen> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<void> secureScreen() async {

    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  @override
  void initState() {
    // TODO: implement initState
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
      appBar: AppBar(
         title: const Text("Download Wallpaper"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:firestore.collection("/most-popular").doc(FirebaseAuth.instance.currentUser?.uid).collection("/popular").where("id",isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return MasonryGridView.count(
              physics: BouncingScrollPhysics(),



              scrollDirection: Axis.vertical,

              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {

                return InkWell(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SetWallPaper(
                       currentIndex: index,
                        id: "",
                        database: "/most-popular",
                        sub: "/popular",
                        image: snapshot.data?.docs[index]["image"],
                        title: snapshot.data?.docs[index]["title"])));

                  },
                  child: Hero(
                    tag: "${index}",
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child:  Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("${snapshot.data?.docs[index]["image"]}"),
                                ),
                              ),
                             /* child:  snapshot.data?.docs[index]["type"]=="free"?Container():Banner(
                                  color: Colors.pinkAccent,

                                  message: "${snapshot.data?.docs[index]["type"]}", location: BannerLocation.topEnd),*/
                              //child: Image.network("${snapshot.data?.docs[index]["image"]}",fit: BoxFit.cover,)
                            ),

                          ),




                        ],
                      ),
                    ),
                  ),
                );
              },

              crossAxisCount: 3,



            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
