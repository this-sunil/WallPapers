import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_app/page/DetailPage.dart';
import 'package:wallpaper_app/page/SetWallPaper.dart';



class WallPaperSearch extends SearchDelegate{
  /*final String title;*/
  WallPaperSearch(/*{required this.title}*/);
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
  final FirebaseAuth auth=FirebaseAuth.instance;
  @override
  String get searchFieldLabel =>'Search here ....';
  @override
  TextStyle get searchFieldStyle => const TextStyle(fontSize: 16);
  @override
  // TODO: implement searchFieldDecorationTheme
  InputDecorationTheme? get searchFieldDecorationTheme => const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white38),

  );
  int id=0;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(

      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.white,
        cursorColor: Colors.white,

      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(

        headline6: TextStyle(
          color: Colors.white,

          fontSize: 18.0,
        ),
      ),
    );
    return theme;
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      query.isNotEmpty?IconButton(onPressed: (){
        query="";
      }, icon: const Icon(Icons.close,color: Colors.white)):IconButton(onPressed: (){

      }, icon: const Icon(Icons.search,color: Colors.white)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(icon: AnimatedIcon(icon:AnimatedIcons.menu_arrow, color: Colors.white,progress: transitionAnimation),onPressed: (){
      Navigator.pop(context);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return StreamBuilder(
        stream: firestore.collection("/category").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final suggestionList=query.isEmpty?[]:snapshot.data!.docs.where((element) => element["title"].toString().toLowerCase().startsWith(query)).toList();

            // print(suggestionList[0]["title"]);
            return suggestionList.isEmpty?SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/no-internet.json"),
                  Center(child: Text("Data not Found",style: TextStyle(color: Colors.black),)),
                ],
              ),
            ):ListView.builder(

              physics: const BouncingScrollPhysics(),

              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      /*title=="category"?*/firestore.collection("/category").where("title",isEqualTo:suggestionList[index]["title"]).get().then((value){
                        String id=value.docs[index].id;
                        print(id);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(id: id, title: capitalize(suggestionList[index]["title"]))));
                      });/*:
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SetWallPaper(currentIndex: index,title: title,id: "",database: "/$title",sub: "", image: '',)));*/
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(

                        leading: Hero(
                          tag: "${suggestionList[index]["image"]}",
                          child: CircleAvatar(
                            backgroundImage:NetworkImage("${suggestionList[index]["image"]}"),
                          ),
                        ),
                        title:RichText(text: TextSpan(
                          text: suggestionList[index]["title"].substring(0,query.length),
                          style:const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: suggestionList[index]["title"].substring(query.length),
                              style:const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )),


                      ),
                    ));


              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {


    return StreamBuilder(
        stream: firestore.collection("/category").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
         final suggestionList=query.isEmpty?[]:snapshot.data!.docs.where((element) => element["title"].toString().toLowerCase().startsWith(query)).toList();
          // print(suggestionList[0]["title"]);
            return suggestionList.isEmpty?SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/no-internet.json"),
                  Center(child: Text("Data not Found",style: TextStyle(color: Colors.black))),
                ],
              ),
            ):ListView.builder(

              physics: const BouncingScrollPhysics(),

              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {

                  showResults(context);
                  id=index;

              },
                  child: ListTile(

                    leading: Hero(
                      tag: "${suggestionList[index]["image"]}",
                      child: CircleAvatar(
                        backgroundImage:NetworkImage("${suggestionList[index]["image"]}"),
                      ),
                    ),
                       title:RichText(text: TextSpan(
                         text: suggestionList[index]["title"].substring(0,query.length),
                         style:const TextStyle(color: Colors.black),
                         children: [
                           TextSpan(
                             text: suggestionList[index]["title"].substring(query.length),
                             style:const TextStyle(color: Colors.grey),
                           ),
                         ],
                       )),


                        ));


              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}