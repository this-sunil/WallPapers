import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<QuerySnapshot> searchData = [];
  Stream<QuerySnapshot> fetchSearchData() async* {
  await  firestore.collection("/category").get().then((value){
     for(int i=0;i<value.docs.length;i++){
       firestore
           .collection("/category")
           .doc(value.docs[i].id)
           .collection("/data").where("title",isEqualTo: "Nature")
           .snapshots();
       print("id ${value.docs[i].id}");
       //searchData.add(DataModel(name: value.docs[i]["title"],image: value.docs[i]["image"]));
       print(searchData);

     }

   });


  }

  @override
  void initState() {
    setState(() {
      fetchSearchData();
      print("data");
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
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black),onPressed: (){
          Navigator.pop(context);
        }),
        backgroundColor: Colors.white,
        title:Card(
          elevation: 0,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
        ),

      body: name.isEmpty?Container():StreamBuilder<QuerySnapshot>(
        stream: fetchSearchData(),
        builder: (context, snapshot) {

          return (!snapshot.hasData)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {

                    return Card(
                      child: Row(
                        children: <Widget>[
                       Image.network(
                            snapshot.data?.docs[index]["image"],
                            width: 150,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                         Text(
                            snapshot.data?.docs[index]["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
