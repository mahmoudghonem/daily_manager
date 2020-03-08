import 'package:daily_manager/data/tasksModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TasksDataBaseService {
  String path;
  Database _database;
  final int _version = 1;
  final String tableName = 'Tasks';

  TasksDataBaseService();
  static final TasksDataBaseService db = TasksDataBaseService();

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we will initlize.. it
    _database = await init();
    return _database;
  }

  init() async {
    path = await getDatabasesPath();
    path = join(path, 'tasks.db');

    return await openDatabase(path, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, content TEXT, date TEXT, isDone INTEGER)',
          );
    });
  }

  Future<List<TasksModel>> getTasksFromDB() async {
    final db = await database;
    List<TasksModel> tasksList = [];
    List<Map> maps =
        await db.query('$tableName', columns: ['id', 'content', 'date', 'isDone']);
    if (maps.length > 0) {
      maps.forEach((map) {
        tasksList.add(TasksModel.fromMap(map));
      });
    }
    return tasksList;
  }

  Future<void> updateTaskInDB(TasksModel updatedTask) async {
    final db = await database;
    await db.update('Tasks', updatedTask.toMap(),
        where: 'id = ?', whereArgs: [updatedTask.id]);
  }

  Future<void> deleteTaskInDB(TasksModel taskToDelete) async {
    final db = await database;
    await db.delete('Tasks', where: 'id = ?', whereArgs: [taskToDelete.id]);
  }

  Future<int> addTaskInDB(TasksModel newTask) async {
    final db = await database;
    var results = db.insert(tableName, newTask.toMap());
    return results;
  }

  Future close() async => _database.close();
}
