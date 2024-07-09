import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../entity/note.dart';

class NoteDBHelper {
  static final NoteDBHelper _instance = NoteDBHelper._internal();
  static NoteDBHelper getInstance() => _instance;
  NoteDBHelper._internal();

  Database? _db;
  static final String _Notes = "_Notes";

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
    var dbPath = path.join(await databaseFactory.getDatabasesPath(), "notes_3.db");
    print("dbPath: " + dbPath);

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          print("Creating database");
          await db.execute(
              "CREATE TABLE $_Notes ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "userId INTEGER,"
                  "title TEXT,"
                  "content TEXT,"
                  "time INTEGER,"
                  "star INTEGER,"
                  "weather INTEGER,"
                  "mood INTEGER"
                  ")"
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute("ALTER TABLE $_Notes ADD COLUMN userId INTEGER"); // Upgrade to add userId field
          }
        },
      ),
    );
  }

  Future<int> insert(Note note) async {
    Database db = await database;
    print("insert function called, data to insert:" + note.toMap().toString());
    return await db.insert(_Notes, note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Note?> findNoteById(int id) async {
    Database db = await database;
    final List<Map<String, Object?>> noteMaps = await db.query(
      _Notes,
      where: "id = ?",
      whereArgs: [id],
    );
    if (noteMaps.isNotEmpty) {
      return Note.fromMap(noteMaps.first);
    }
    return null;
  }

  Future<List<Note>> findNotesByUserId(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      _Notes,
      where: "userId = ?",
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        userId: maps[i]['userId'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        time: maps[i]['time'],
        star: maps[i]['star'],
        weather: maps[i]['weather'],
        mood: maps[i]['mood'],
      );
    });
  }

  Future<List<Note>> findNotesByKeyword(String keyword) async {
    Database db = await database;
    final List<Map<String, Object?>> noteMaps = await db.query(
      _Notes,
      where: "title LIKE ? OR content LIKE ?",
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return List.generate(noteMaps.length, (i) {
      return Note.fromMap(noteMaps[i]);
    });
  }

  Future<List<Note>> findNotesByKeywordAndUserId(String keyword, int userId) async {
    Database db = await database;
    final List<Map<String, Object?>> noteMaps = await db.query(
      _Notes,
      where: "userId = ? AND (title LIKE ? OR content LIKE ?)",
      whereArgs: [userId, '%$keyword%', '%$keyword%'],
    );
    return List.generate(noteMaps.length, (i) {
      return Note.fromMap(noteMaps[i]);
    });
  }

  Future<int> deleteNoteById(int id) async {
    Database db = await database;
    return await db.delete(
      _Notes,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Note note) async {
    print("update: note=" + note.toMap().toString());
    Database db = await database;
    return db.update(_Notes, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }



// New method to find notes by user ID and star status
  Future<List<Note>> findNotesByUserIdAndStar(int userId, int starStatus) async {
    Database db = await database;
    final List<Map<String, Object?>> noteMaps = await db.query(
      _Notes,
      where: "userId = ? AND star = ?",
      whereArgs: [userId, starStatus],
    );
    return List.generate(noteMaps.length, (i) {
      return Note.fromMap(noteMaps[i]);
    });
  }

// New method to update star status by note ID
  Future<int> updateNoteStarById(int id, int starStatus) async {
    Database db = await database;
    return db.rawUpdate(
      'UPDATE $_Notes SET star = ? WHERE id = ?',
      [starStatus, id],
    );
  }



  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}
