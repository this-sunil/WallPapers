import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';
class MostPopularScreen extends StatefulWidget {
  const MostPopularScreen({Key? key}) : super(key: key);

  @override
  State<MostPopularScreen> createState() => _MostPopularScreenState();
}

class _MostPopularScreenState extends State<MostPopularScreen> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  var counts;
  List<int> count=[];
  Future<void> secureScreen() async {

    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  fetchData() async{
    FirebaseFirestore.instance.collection("popular").get().then((value){
      setState(() {
        value.docs.map((e){
          setState(() {

            counts=count.reduce((value, element) => value > element ? value: element);
            count.addAll(counts);
            print("count ${counts}");
          });
        }).toList();
        print("count ${count}");

      });
    });
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

      body:
      StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("popular").snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return MasonryGridView.custom(

                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                childrenDelegate: SliverChildBuilderDelegate(
                        childCount: snapshot.data?.docs.length,

                        (context, index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SetWallPaper(id: "${snapshot.data?.docs[index].id}",database: "/popular",title: snapshot.data?.docs[index]['title'],currentIndex: index, sub: '',image: snapshot.data?.docs[index]["image"])));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: "${index}",
                            child: Container(
                              height: index.isEven?200:150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("${snapshot.data?.docs[index]["image"]}"),
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
