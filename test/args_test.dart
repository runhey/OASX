import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:oasx/views/args/args_view.dart';

void main() {
  test('Counter value should be incremented', () {
    ArgsTest argsTest = ArgsTest();
    argsTest.testArgsView();

    // expect(argsTest.testArgsView, 1);
  });
}

class ArgsTest {
  void testArgsView() {
    File jsonFile = File(
        '${Directory.current.path}\\lib\\controller\\args\\task.json'); // 替换为您的 JSON 文件路径
    String jsonString = jsonFile.readAsStringSync();
    ArgsController c = ArgsController();
    c.loadModelfromStr(jsonString);
  }
}
