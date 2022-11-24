import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallpaper_app/Service/Favourite.dart';
class DatabaseHelper{
  late Database database;
  Future<Database> init() async{

    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "wallpaper.db");
   Database db=await openDatabase(dbPath,version: 1,onCreate: create);
    return db;

  }
  create(Database db,int version) async{
    await db.execute("""CREATE TABLE Fav(title TEXT,image TEXT,type TEXT)""");
  }
  addFav(String title,String image,String type) async{
    database=await init();
    database.insert("Fav", {"title":title,"image":image,"type":type}).then((value) => Fluttertoast.showToast(msg: "Favourite WallPaper added Successfully"));
  }
  removeFav(String title) async{
    database=await init();
    database.delete("Fav",where: "title=?",whereArgs: [title]).then((value) => Fluttertoast.showToast(msg: "Favourite WallPaper remove Successfully"));
  }
  Future<List<Favourite>> fetchFav() async {
    database=await init();
    List<Map<String,dynamic>> results = await database.query("Fav",columns: ["title","image","type"]);

    List<Favourite> fav=[];
    if(results.isNotEmpty)
    {
      results.map((e){
        fav.add(Favourite(title: e["title"], image: e["image"],type: e["type"]));
      }).toList();
    }
    return fav;
  }
}