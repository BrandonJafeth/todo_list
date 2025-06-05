import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'todo_list.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'createdAt DESC');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [isCompleted ? 1 : 0],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> toggleTaskStatus(int id) async {
    final db = await database;
    final tasks = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (tasks.isNotEmpty) {
      final task = Task.fromMap(tasks.first);
      return await db.update(
        'tasks',
        {'isCompleted': task.isCompleted ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    return 0;
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}
