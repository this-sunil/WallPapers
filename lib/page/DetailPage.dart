import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';

class DetailPage extends StatefulWidget {
  final String id;
  final String title;
  const DetailPage({Key? key,required this.id,required this.title}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
int count=0;
FirebaseFirestore firestore=FirebaseFirestore.instance;
FirebaseAuth firebaseAuth=FirebaseAuth.instance;
bool paymentSuccess=false;
bool paymentError=false;
String name="";
String success="";
String currentID="";
int currentIndex=0;

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
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        elevation: 0,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("/category").doc(widget.id).collection("/data").snapshots(),
        builder: (context,snapshot){
        if(snapshot.hasData){
          return MasonryGridView.count(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {

              return InkWell(
                onTap: (){
                  FirebaseFirestore.instance.collection("/category").doc(widget.id).collection("/data").get().then((value){

                     print("previous image $index ${snapshot.data!.docs[index]["image"]}");

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SetWallPaper(title: snapshot.data?.docs[index]["title"],database: "/category",id: widget.id,currentIndex:index, sub: '',image: snapshot.data?.docs[index]["image"])));

                  });
                },
                child:
                Hero(
                  tag: "${snapshot.data?.docs[index]["image"]}",
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                                child:  snapshot.data?.docs[index]["type"]=="free"?Container():Banner(
                                    color: Colors.pinkAccent,

                                    message: "${snapshot.data?.docs[index]["type"]}", location: BannerLocation.topEnd),
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
        return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
