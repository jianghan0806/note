//user_db_helper
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:notes1/entity/user.dart';

class DBHelper {
  static DBHelper? _dbHelper;

  static DBHelper getInstance() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper();
    }
    return _dbHelper!;
  }

  Database? _db;
  static final String _Users = "_Users"; // User 表

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var dbPath = path.join(await databaseFactory.getDatabasesPath(), "user_1.db");
    print("dbPath: " + dbPath);

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          print("创建数据库");
          return await db.execute(
            "CREATE TABLE $_Users ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                "username TEXT,"
                "password TEXT,"
                "sex TEXT,"
                "constellation TEXT,"
                "hobby TEXT,"
                "signature TEXT"
                ")",
          );
        },
      ),
    );
  }

  Future<int> insert(User user) async {
    Database db = await database;
    print("insert function called，插入的数据:" + user.toMap().toString());
    return await db.insert(_Users, user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(User user) async {
    print("update: user=" + user.toMap().toString());
    Database db = await database;
    return db.update(_Users, user.toMap(), where: 'id=?', whereArgs: [user.id]);
  }

  Future<List<User>> findUserByUsernameAndPassword(String username, String password) async {
    Database db = await database;
    final List<Map<String, Object?>> userMaps = await db.query(
      _Users,
      where: "username = ? and password = ?",
      whereArgs: [username, password],
    );
    print("findUserByUsernameAndPassword function called: userMaps.length=" + userMaps.length.toString());
    return List.generate(userMaps.length, (i) {
      return User.fromMap(userMaps[i]);
    });
  }

  Future<List<User>> findUserByUsername(String username) async {
    Database db = await database;
    final List<Map<String, Object?>> userMaps = await db.query(
      _Users,
      where: "username = ?",
      whereArgs: [username],
    );
    print("findUserByUsername function called: userMaps.length=" + userMaps.length.toString());
    return List.generate(userMaps.length, (i) {
      return User.fromMap(userMaps[i]);
    });
  }

  Future<List<User>> findUserById(int id) async {
    Database db = await database;
    final List<Map<String, Object?>> userMaps = await db.query(
      _Users,
      where: "id = ?",
      whereArgs: [id],
    );
    return List.generate(userMaps.length, (i) {
      return User.fromMap(userMaps[i]);
    });
  }

  Future<String> getUsernameById(int id) async {
    Database db = await database;
    final List<Map<String, Object?>> userMaps = await db.query(
      _Users,
      columns: ['username'],
      where: "id = ?",
      whereArgs: [id],
    );
    if (userMaps.isNotEmpty) {
      return userMaps.first['username'] as String;
    } else {
      return 'Unknown';
    }
  }
}
