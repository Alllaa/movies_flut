import 'dart:io' as io;

import 'package:movieapp/models/favourite.dart';
import 'package:movieapp/models/favourite_trailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

String join(String a,String b)
{
  return "$a/$b";
}
class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;


  Future<Database>get db async{
      if(_db != null) return _db;
      _db = await initDb();
  }
  DatabaseHelper.internal();

  initDb()async{
    io.Directory documentDirectoy = await getApplicationDocumentsDirectory();
    String path = join(documentDirectoy.path,"moviefavourites.db");
    var theDb = await openDatabase(path,version: 1,onCreate:  _onCreate);
    return theDb;
  }
  void _onCreate(Database db ,int version)async{
    await db.execute(
      "CREATE TABLE Favourites(id INTEGER PRIMARY KEY,name TEXT,movie_id INT,poster_path BLOB,release_date TEXT,vote_count TEXT,vote_average TEXT,genres TEXT,description TEXT,popularity TEXT)");
    await db.execute(
      "CREATE TABLE FavouritesTrailer(id INTEGER PRIMARY KEY,movie_id INT,title TEXT,link TEXT)"
    );
  }
  

  Future<int> insertMovie(Favourite favourite)async{
    var dbClient = await db;
    List<Map>list = await dbClient.rawQuery(
      "SELECT * FROM Favourites WHERE movie_id = ?",[favourite.movie_id]
    );
    int res;
    list.length == 0 ?{res = await dbClient.insert("Favourites", favourite.toMap())} : {};
    return res;
  }
  Future<int> insertMovieTrailer(Trailer favouriteTrailer)async
  {
    var dbClient = await db;
    int res  = await dbClient.insert("FavouritesTrailer", favouriteTrailer.toMap());
    return res;
  }
  Future<List<Favourite>> getFavourites()async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Favourites ORDER BY id DESC");
    List<Favourite> favourites = new List();
    for(var i =0; i <list.length;i++)
      {
        var favourite = new Favourite(
          list[i]["name"],
          list[i]["movie_id"],
          list[i]["poster_path"],
          list[i]["release_date"],
          list[i]["vote_count"],
          list[i]["vote_average"],
          list[i]["genres"],
          list[i]["description"],
          list[i]["popularity"]
        );
        favourite.setFavouriteId(list[i]["id"]);
        favourites.add(favourite);
      }
    return favourites;
  }
  Future<List<Trailer>>getMoviesTrailer(int movie_id)async{
    var dbClient = await db;
    List<Map>list  = await dbClient.rawQuery("SELECT * FROM FavouritesTrailer WHERE movie_id = ?",[movie_id]);
    List<Trailer>favourite = new List();
    for(var i =0; i <list.length;i++)
      {
        var map = new Map<String,dynamic>();
        Trailer d = new Trailer(list[i]["title"],list[i]["link"]);
        d.movie_id = movie_id;
        favourite.add(d);
      }
    return favourite;

  }
  Future <int> deleteFavourite(int movie_id)async{
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM Favourites WHERE movie_id = ?",[movie_id]);
    return res;
  }
  Future <int> deleteFavouriteTrailer(int movie_id)async{
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM FavouritesTrailer WHERE movie_id = ?",[movie_id]);
    return res;
  }
  Future <bool> update(Favourite favourite)async{
    var dbClient = await db;
    int res = await dbClient.update("Favourites", favourite.toMap(),where: "id =?",whereArgs: <int>[favourite.id]);
    return res >0 ?true:false;
  }

  Future <bool> isItRecord(int movie_id)async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Favourites WHERE movie_id =?",[movie_id]);
    return list.length > 0 ? true : false;
  }
}