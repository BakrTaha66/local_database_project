import 'package:local_database_project/constants.dart';
import 'package:local_database_project/info_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database>? get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'InfoDatabase.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // CREATE TABLE t1(a, b PRIMARY KEY)
  Future<void> _onCreate(Database? db, int? version) async {
    db!.execute('''
    CREATE TABLE $infoTable (
    $columnID $idType,
    $columnName $textType,
    $columnPhone $textType,
    $columnEmail $textType
    )
    ''');
  }

  /// CRUD OPERATION (CREATE - READ - UPDATE - DELETE)
  /// CREATE
  Future<void> insertInfo(InfoModel info) async {
    final db = await instance.database;
    db!.insert(
      infoTable,
      info.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// READ
  Future<List<InfoModel>> readAllInfo() async {
    final db = await instance.database;
    List<Map<String, dynamic>> data = await db!.query(infoTable);

    return data.isNotEmpty
        // MAP LOOPING
        ? data.map((element) => InfoModel.fromDB(element)).toList()
        : [];
  }

  Future<InfoModel> readOneInfo(int id) async {
    final db = await instance.database;
    List<Map<String, dynamic>> data = await db!.query(
      infoTable,
      where: '$columnID = ?',
      whereArgs: [id],
    );

    return data.isNotEmpty
        ? InfoModel.fromDB(data.first)
        : throw Exception('Id $id is not found');
  }

  /// UPDATE
  Future<void> editInfo(InfoModel info) async {
    final db = await instance.database;
    db!.update(
      infoTable,
      info.toDB(),
      where: '$columnID = ?',
      whereArgs: [info.id],
    );
  }

  // Future<void> insertInfo(InfoModel info) async {
  //   final db = await instance.database;
  //   db!.insert(
  //     infoTable,
  //     info.toDB(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  /// DELETE
  Future<void> deleteInfo(int id) async {
    final db = await instance.database;
    db!.delete(
      infoTable,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }
}

//  sql lite datatype
