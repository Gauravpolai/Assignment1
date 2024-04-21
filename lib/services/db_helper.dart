import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = "Assignment1.db";
  static const dbVersion = 1;
  static const dbTable = "AssignmentTable";
  static const columnId = "id";
  static const keyCol = "key";
  static const valCol = "value";
  //constructor
  static final DatabaseHelper instance = DatabaseHelper();

  //database initialize
  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
  }

  initDB() async {
    String directory = await getDatabasesPath();
    String path = join(directory, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: onCreate,
    );
  }

  Future onCreate(Database db, int version) async {
    db.execute(''' 
      CREATE TABLE $dbTable(
         $keyCol TEXT NOT NULL,
         $valCol TEXT NOT NULL
      )
      ''');
  }

//Create
  insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

//Read
  Future<List<Map<String, dynamic>>> read() async {
    Database? db = await instance.database;
    var dbquery = await db!.query(dbTable);
    return dbquery;
  }

//Update Method
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(dbTable, row, where: '$columnId=?', whereArgs: [id]);
  }

//Delete Method
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(dbTable, where: '$columnId=?', whereArgs: [id]);
  }

  clearUserTable() async {
    Database? db = await instance.database;
    return await db!.rawDelete("DELETE FROM $dbTable");
  }
}
