import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DebugLogger {
  static final DebugLogger _instance = DebugLogger._internal();
  factory DebugLogger() => _instance;
  DebugLogger._internal();

  // === State ===
  File? _logFile;
  String? _activeTask;
  DateTime? _taskStartTime;
  bool _initialized = false;

  // === Initialization ===
  Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'debug_log.csv';
    _logFile = File(path.join(dir.path, fileName));
    await _logFile!.writeAsString(
      'timestamp,eventType,taskId,screen,details\n',
    );
    _initialized = true;
  }

  // === File Writing ===
  void _write(String line) {
    if (!_initialized) return;
    _logFile!.writeAsStringSync(line, mode: FileMode.append);
  }

  // === Task Control ===
  void startTask(String taskId) {
    if (_activeTask != null) {
      endTask(_activeTask!);
    }
    _activeTask = taskId;
    _taskStartTime = DateTime.now();
    _write('${DateTime.now().toIso8601String()},TASK_START,$taskId,,,\n');
  }

  void endTask(String taskId) {
    if (_activeTask == taskId) {
      _write('${DateTime.now().toIso8601String()},TASK_END,$taskId,,,\n');
      _activeTask = null;
      _taskStartTime = null;
    } else {
      _write('${DateTime.now().toIso8601String()},TASK_END,$taskId,,,\n');
    }
  }

  // === Event Logging ===
  void logTap({String? details}) {
    _write('${DateTime.now().toIso8601String()},TAP,${_activeTask ?? "none"},,${details ?? ""}\n');
  }

  void logNavigation(String screenName, {String? details}) {
    _write('${DateTime.now().toIso8601String()},NAVIGATE,${_activeTask ?? "none"},$screenName,${details ?? ""}\n');
  }

  void logCustom(String eventType, {String? taskId, String? screen, String? details}) {
    final tid = taskId ?? _activeTask ?? 'none';
    _write('${DateTime.now().toIso8601String()},$eventType,$tid,${screen ?? ""},${details ?? ""}\n');
  }

  // === Getters ===
  String? get activeTask => _activeTask;
  DateTime? get taskStartTime => _taskStartTime;
}