//fb_database_helper
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:notes1/entity/user_feedback.dart';

class DBHelper {
  static DBHelper? _instance;
  late Database _db;
  static final String _Feedbacks = "_Feedbacks";

  DBHelper._(); // Private constructor for singleton pattern

  factory DBHelper.getInstance() {
    _instance ??= DBHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    if (_db.isOpen) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var dbPath = path.join(await databaseFactory.getDatabasesPath(), "feedbacks.db");

    _db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE $_Feedbacks ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                "userId INTEGER,"
                "feedback TEXT,"
                "timestamp INTEGER"
                ")",
          );
        },
      ),
    );
    return _db;
  }

  Future<int> saveFeedback(UserFeedback feedback) async {
    Database db = await database;
    int id = await db.insert(_Feedbacks, feedback.toMap());
    return id;
  }

  Future<List<UserFeedback>> getAllFeedbacks() async {
    Database db = await database;
    final List<Map<String, dynamic>> feedbackMaps = await db.query(_Feedbacks);
    return List.generate(feedbackMaps.length, (i) {
      return UserFeedback.fromMap(feedbackMaps[i]);
    });
  }


}
