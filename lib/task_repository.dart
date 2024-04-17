import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/task_model.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._();
 late  Database _database;

  TaskRepository._();

  factory TaskRepository() => _instance;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, completed INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> addTask(Task task) async {
    await _database.insert('tasks', task.toJson());
  }

  Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> tasks = await _database.query('tasks');
    return List.generate(tasks.length, (i) {
      return Task.fromJson(tasks[i]);
    });
  }

  Future<void> updateTask(Task task) async {
    await _database.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    await _database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
