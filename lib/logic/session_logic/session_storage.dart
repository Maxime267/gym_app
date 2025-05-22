import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../session_logic/workout_program_class.dart';

class SessionStorage {
  static Future<Directory> get _directory async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> _getIndexFile() async {
    final dir = await _directory;
    return File('${dir.path}/session_index.json');
  }

  static Future<void> saveSession(String sessionId, List<workout_program> exercises) async {
    final file = await _getSessionFile(sessionId);
    final data = exercises.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(data));
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

  static Future<void> deleteSession(String sessionId) async {
    final file = await _getSessionFile(sessionId);
    if (await file.exists()) {
      await file.delete();
    }
    final indexFile = await _getIndexFile();
    final index = await loadSessionIndex();
    index.remove(sessionId);
    await indexFile.writeAsString(json.encode(index));
  }

  static Future<void> saveSessionName(String sessionId, String name) async {
    final file = await _getIndexFile();
    final index = await loadSessionIndex();
    index[sessionId] = name;
    await file.writeAsString(json.encode(index));
  }

  static Future<Map<String, String>> loadSessionIndex() async {
    final file = await _getIndexFile();
    if (!(await file.exists())) return {};
    final content = await file.readAsString();
    return Map<String, String>.from(json.decode(content));
  }

  static Future<List<String>> listAllSessionIds() async {
    final index = await loadSessionIndex();
    return index.keys.toList();
  }
}