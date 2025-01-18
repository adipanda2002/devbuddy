import 'package:devbuddy/src/models/project.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Projects.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Project(id INTEGER PRIMARY KEY, description TEXT NOT NULL, stack TEXT NOT NULL, tags TEXT NOT NULL)"),
        version: _version);
  }

  static Future<int> addProject(Project project) async {
    final db = await _getDB();
    return await db.insert("Project", project.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateProject(Project project) async {
    final db = await _getDB();
    return await db.update('Projects', project.toJson(),
        where: 'id = ?',
        whereArgs: [project.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteProject(Project project) async {
    final db = await _getDB();
    return await db
        .delete('Projects', where: 'id = ?', whereArgs: [project.id]);
  }

  static Future<List<Project>?> getAllProjects() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('Projects');

    if(maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Project.fromJson(maps[index]));
  }
}
