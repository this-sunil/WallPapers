import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/Service/DataBaseHelper.dart';
import 'package:wallpaper_app/Service/Favourite.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  DatabaseHelper databaseHelper=DatabaseHelper();
  @override
  void initState() {
    setState(() {
      databaseHelper.init();
    });
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
        title: Text("Like Wallpaper"),
      ),
      body:FutureBuilder<List<Favourite>>(
        future: databaseHelper.fetchFav(),
        builder: (context,snapshot){
          if(snapshot.hasData){
              return GridView.builder(
                  itemCount: snapshot.data?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 2), itemBuilder: (context,index){
                return InkWell(
                  onTap: (){


                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (
                           context) =>
                           SetWallPaper(
                               currentIndex: index,
                               id: "",
                               database: "/Fav",
                               sub: "",
                               image: snapshot.data![index].image,
                               title: snapshot.data![index].title,
                           )));

                  },
                  child: Hero(
                    tag: "${index}",
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,

                              image: NetworkImage("${snapshot.data![index].image}"),
                            ),
                          ),
                          child: snapshot.data![index].type=="free"?Container():Banner(
                              color: Colors.pinkAccent,
                              message: "${snapshot.data![index].type}", location: BannerLocation.topEnd),
                          //child: Image.network("${snapshot.data?.docs[index]["image"]}",fit: BoxFit.cover,)
                        ),
                      ),
                    ),
                  ),
                );

              });
            }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/*StreamBuilder<QuerySnapshot>(

        stream: firestore.collection("/Fav").doc(FirebaseAuth.instance.currentUser?.uid).collection("/like").where("id",isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return GridView.builder(
              itemCount: snapshot.data?.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2), itemBuilder: (context,index){
                return InkWell(
                  onTap: (){

                  /* if(snapshot.data?.docs[index]["type"]=="premium"){
                     Navigator.push(context,MaterialPageRoute(builder: (context)=>const FavPremium()));
                   }
                   else{*/
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>SetWallPaper(
                         currentIndex: index,
                         id: "",
                         database: "/Fav",
                         sub: "/like",
                         image: snapshot.data?.docs[index]["image"],
                         title: snapshot.data?.docs[index]["title"]
                     )));

                  },
                  child: Hero(
                    tag: "${index}",
                    child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
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
                        child:  snapshot.data?.docs[index]["type"]=="free"?Container():Banner(
                            color: Colors.pinkAccent,
                            message: "${snapshot.data?.docs[index]["type"]}", location: BannerLocation.topEnd),
                        //child: Image.network("${snapshot.data?.docs[index]["image"]}",fit: BoxFit.cover,)
                      ),
                    ),
                    ),
                  ),
                );

            });
          }
          return Center(child: CircularProgressIndicator());
        },
      )*///