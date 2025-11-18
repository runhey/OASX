import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

late Logger logger;

Future<void> initLogger() async {
  getApplicationCacheDirectory().then((appDocDir) {
    String logPath = appDocDir.path;
    Directory logDir = Directory('$logPath/logs');
    if (!logDir.existsSync()) {
      logDir.createSync(recursive: true);
    }
    String dateTime = DateTime.now().toIso8601String().substring(0, 10);
    logger = _getLogger(logDir.path, dateTime);
    logger.i('log path: ${logDir.path}/$dateTime.txt');
    logger.i('App path: ${Directory.current.path}');

    _cleanupOldLogs(logDir.path);
  });
}

class CustomConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      stdout.write('$line\n');
    }
  }
}

Logger _getLogger(String logPath, String dateTime) {
  //
  LogFilter filter = ProductionFilter();
  //
  LogPrinter printer = SimplePrinter(printTime: true);
  //
  MultiOutput multiOutput = MultiOutput([
    FileOutput(
      file: File('$logPath/$dateTime.txt'),
      encoding: utf8,
    ),
    CustomConsoleOutput(),
  ]);

  return Logger(
    filter: filter,
    printer: printer,
    output: multiOutput,
  );
}

Future<void> _cleanupOldLogs(String logDirPath) async {
  try {
    final logDir = Directory(logDirPath);
    if (!logDir.existsSync()) return;

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final files = logDir.listSync();
    int deletedCount = 0;
    for (var file in files) {
      if (file is File && file.path.endsWith('.txt')) {
        // 从文件名提取日期（假设文件名格式为 "yyyy-MM-dd.txt"）
        final fileName = file.uri.pathSegments.last;
        if (fileName.length >= 14 && fileName.endsWith('.txt')) {
          try {
            final dateStr = fileName.substring(0, 10);
            final fileDate = DateTime.parse(dateStr);
            if (fileDate.isBefore(thirtyDaysAgo)) {
              await file.delete();
              deletedCount++;
            }
          } catch (e) {
            continue;
          }
        }
      }
    }

    if (deletedCount > 0) {
      logger.i('Cleaned up $deletedCount old log files');
    }
  } catch (e) {
    logger.e('Error cleaning up old logs: $e');
  }
}
