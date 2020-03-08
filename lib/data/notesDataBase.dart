import 'package:daily_manager/data/notesModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDataBaseService {
  String path;
  Database _database;
  final int _version = 1;
  final String tableName = 'Notes';

  NotesDataBaseService();

  static final NotesDataBaseService db = NotesDataBaseService();

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we will initlize.. it
    _database = await init();
    return _database;
  }

  init() async {
    path = await getDatabasesPath();
    path = join(path, 'notes.db');

    return await openDatabase(path, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, content TEXT, date TEXT, isFav INTEGER)',
          );
    });
  }

  Future<List<NotesModel>> getNotesFromDB() async {
    final db = await database;
    List<NotesModel> notesList = [];
    List<Map> maps =
        await db.query('Notes', columns: ['id', 'content', 'date', 'isFav']);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    return notesList;
  }

  Future<void> updateNoteInDB(NotesModel updatedNote) async {
    final db = await database;
    await db.update('Notes', updatedNote.toMap(),
        where: 'id = ?', whereArgs: [updatedNote.id]);
  }

  Future<void> deleteNoteInDB(NotesModel noteToDelete) async {
    final db = await database;
    await db.delete('Notes', where: 'id = ?', whereArgs: [noteToDelete.id]);
  }

  Future<int> addNoteInDB(NotesModel newNote) async {
    final db = await database;
    var results = db.insert(tableName, newNote.toMap());
    return results;
  }

  Future close() async => _database.close();
}
