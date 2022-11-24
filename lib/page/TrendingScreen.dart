import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  FirebaseFirestore firestore =FirebaseFirestore.instance;
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("/trending-images").snapshots(),
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
                         id: snapshot.data!.docs[index].id,
                          database: "/trending-images",
                          image: snapshot.data?.docs[index]["image"],
                          title: snapshot.data?.docs[index]["title"],currentIndex: index, sub: '',)));

                  },
                  child: Card(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  Column(
                      children: [
                        Hero(
                          tag: "${index}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network("${snapshot.data?.docs[index]["image"]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),




                      ],
                    ),
                  ),
                );
              },

              crossAxisCount: 3,



            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
