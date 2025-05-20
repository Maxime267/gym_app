import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../session_logic/workout_program_class.dart';

class SessionStorage {
  static Future<Directory> get _directory async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  static Future<File> _getSessionFile(String sessionId) async {
    final dir = await _directory;
    return File('${dir.path}/$sessionId.json');
  }

  static Future<List<workout_program>> loadSession(String sessionId) async {
    final file = await _getSessionFile(sessionId);
    if (!(await file.exists())) return [];
    final content = await file.readAsString();
    final List<dynamic> data = json.decode(content);
    return data.map((e) => workout_program.fromJson(e)).toList();
  }

  static Future<void> saveSession(String sessionId, List<workout_program> exercises) async {
    final file = await _getSessionFile(sessionId);
    final List<Map<String, dynamic>> data = exercises.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(data));
  }

  static Future<void> deleteSession(String sessionId) async {
    final file = await _getSessionFile(sessionId);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
