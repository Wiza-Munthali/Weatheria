import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weatheria/models/favouriteModel.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? db;
  Future<Database> get database async => db ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'favourite.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database _db, int version) async {
    await _db.execute('''
    CREATE TABLE favourites(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      city TEXT NOT NULL,
      country TEXT NOT NULL,
      latitude TEXT NOT NULL,
      longitude TEXT NOT NULL
    )
    ''');
  }

  Future<List<FavouriteModel>> getFavourite() async {
    Database db = await instance.database;
    var fav = await db.query('favourites', orderBy: 'city');
    List<FavouriteModel> favs = fav.isNotEmpty
        ? fav.map((e) => FavouriteModel.fromMap(e)).toList()
        : [];

    return favs;
  }

  Future<int> insert(FavouriteModel favouriteModel) async {
    Database database = await instance.database;
    return await database.insert('favourites', favouriteModel.toMap());
  }

  Future<int> delete(id) async {
    Database database = await instance.database;
    return await database
        .delete('favourites', where: 'id = ?', whereArgs: [id]);
  }
}
