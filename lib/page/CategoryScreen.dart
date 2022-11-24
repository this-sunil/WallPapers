import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wallpaper_app/page/DetailPage.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
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
      body:StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("/category").snapshots(),
        builder: (context, snapshot){
         if(snapshot.hasData){
           return MasonryGridView.count(
             crossAxisCount: 2,
             physics: const BouncingScrollPhysics(),
             mainAxisSpacing: 4,
             crossAxisSpacing: 4,
             itemCount: snapshot.data?.docs.length,
             itemBuilder: (context, index) {

               return InkWell(
                 onTap: (){
                   firestore.collection("/category").get().then((value){
                     setState(() {
                       String id=value.docs[index].id;

                       Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(id: id, title: capitalize(snapshot.data?.docs[index]["title"]))));
                     });
                   });

                 },
                 child: Card(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Column(
                     children: [
                       Hero(
                         tag: "${snapshot.data?.docs[index]["image"]}",
                         child: Container(
                           width: MediaQuery.of(context).size.width,
                           height: 200,
                           decoration:  BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             image: DecorationImage(
                               fit: BoxFit.cover,

                               image: NetworkImage("${snapshot.data?.docs[index]["image"]}"),
                             ),
                           ),
                           child: Center(child: Text(capitalize("${snapshot.data?.docs[index]["title"]}"),style: TextStyle(
                             color: Colors.white,
                             fontSize: 25,
                           ),)


                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               );
             },
           );
         }
         return Center(
           child: CircularProgressIndicator(),
         );
        }),

    );
  }
}
