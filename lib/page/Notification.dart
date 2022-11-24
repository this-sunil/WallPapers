import 'dart:collection';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
/*import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';*/
class NotificationDetails extends StatefulWidget {

  const NotificationDetails({Key? key}) : super(key: key);

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  final db=FirebaseFirestore.instance;
  bool flag=false;
  String? deviceToken;

  HashSet<int> select=HashSet();
  onToggle(int index){
    print(index);
    if(select.contains(index)){
      select.remove(index);
    }
    else{
      select.add(index);
    }
    setState(() {

    });
  }
  @override
  void initState() {

    FirebaseMessaging.instance.getToken().then((value){
      setState(() {
        deviceToken=value.toString();
      });
    });
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

        title: const Text("Notification"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: db.collection("/Notification").where("id",isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  var e=snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: InkWell(

                        onTap: (){
                          print("ontap");
                          select.clear();
                          flag=!flag;
                        },
                        onLongPress: (){
                          setState(() {
                            onToggle(index);
                          });
                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children:[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),

                                      child: e.data()["image"]==null?Container(

                                      ):
                                      Ink.image(
                                        height: 200,

                                        fit: BoxFit.cover,


                                        colorFilter:  select.contains(index)?const ColorFilter.mode(Colors.grey, BlendMode.color):null,
                                        image: NetworkImage("${e.data()["image"]}"),

                                        //colorBlendMode: BlendMode.color,
                                        // color:  select.contains(index)?Colors.grey:null),
                                      )),
                                ),
                                Visibility(
                                  visible: select.contains(index),
                                  child: Card(
                                    shape: const StadiumBorder(),
                                    child: IconButton(onPressed: (){
                                      setState(() {
                                        FirebaseFirestore.instance.collection("/Notification").doc(e.id).delete();
                                      });
                                    }, icon: const Icon(Icons.delete_outline)),
                                  ),
                                ),
                              ],
                            ),


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${e.data()["title"]}",style:Theme.of(context).textTheme.headline6),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${e.data()["message"]}",style: Theme.of(context).textTheme.bodyText1),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child:CircularProgressIndicator(),
            );
          }),
    );
  }
}
