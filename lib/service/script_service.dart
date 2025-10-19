import 'dart:convert';

import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/controller/progress_snackbar_controller.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/service/websocket_service.dart';
import 'package:oasx/utils/extension_utils.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/views/overview/overview_view.dart';
import 'package:oasx/utils/time_utils.dart';

class ScriptService extends GetxService {
  final _storage = GetStorage();
  final wsService = Get.find<WebSocketService>();
  final scriptModelMap = <String, ScriptModel>{}.obs;
  final autoScriptList = <String>[].obs;

  @override
  Future<void> onInit() async {
    final scriptList = await ApiClient().getScriptList();
    if (scriptList.isNotEmpty) {
      await Future.wait(scriptList.map((name) => connectScript(name)));
    }
    autoScriptList.value =
        ((jsonDecode(_storage.read(StorageKey.autoScriptList.name)) as List?) ??
                [])
            .map((e) => e.toString())
            .toList();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await autoRunScript();
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    await Future.wait([
      ...scriptModelMap.keys.map((e) => Future.wait([
            stopScript(e),
            wsService.close(e),
            Get.delete<OverviewController>(tag: e, force: true)
          ])),
    ]);
    scriptModelMap.clear();
    super.onClose();
  }

  Future<void> connectScript(String name) async {
    if (!scriptModelMap.containsKey(name)) {
      addScriptModel(name);
    }
    wsService.removeAllListeners(name);
    // 监听ws客户端状态, 脚本状态同步更新
    final client = await wsService.connect(
        name: name, listener: (mg) => wsListener(mg, name));
    client.status.listen((wsStatus) =>
        scriptModelMap[name]?.update(state: wsStatus.scriptState));
  }

  Future<void> startScript(String name) async {
    if (!scriptModelMap.containsKey(name)) return;
    if (isRunning(name)) return;
    await connectScript(name);
    await wsService.send(name, 'start');
  }

  void wsListener(dynamic message, String name) {
    if (message is! String) {
      printError(info: 'Websocket push data is not of type string and map');
      return;
    }
    if (!message.startsWith('{') || !message.endsWith('}')) {
      if (Get.isRegistered<OverviewController>(tag: name)) {
        Get.find<OverviewController>(tag: name).addLog(message);
      }
      return;
    }
    Map<String, dynamic> data = jsonDecode(message);
    if (data.containsKey('state')) {
      scriptModelMap[name]!.update(state: ScriptState.getState(data['state']));
      return;
    }
    if (data.containsKey('schedule')) {
      Map run = data['schedule']['running'];
      List<dynamic> pending = data['schedule']['pending'];
      List<dynamic> waiting = data['schedule']['waiting'];
      TaskItemModel runningTask = run.isNotEmpty
          ? TaskItemModel(name, run['name'], run['next_run'])
          : TaskItemModel.empty();
      final pendingList =
          pending.map((e) => TaskItemModel(name, e['name'], e['next_run'])).toList();
      final waitingList =
          waiting.map((e) => TaskItemModel(name, e['name'], e['next_run'])).toList();
      scriptModelMap[name]!.update(
          runningTask: runningTask,
          pendingTaskList: pendingList,
          waitingTaskList: waitingList);
    }
  }

  Future<void> stopScript(String name) async {
    if (!scriptModelMap.containsKey(name)) return;
    await wsService.send(name, 'stop');
  }

  void addScriptModel(dynamic sm) {
    if (sm is String) {
      sm = ScriptModel(sm);
    }
    if (scriptModelMap.containsKey(sm.name)) return;
    scriptModelMap[sm.name] = sm;
  }

  void updateScriptModel(ScriptModel sm) {
    if (!scriptModelMap.containsKey(sm.name)) return;
    scriptModelMap[sm.name] = sm;
  }

  void addOrUpdateScriptModel(ScriptModel sm) {
    if (scriptModelMap.containsKey(sm.name)) {
      updateScriptModel(sm);
    } else {
      addScriptModel(sm);
    }
  }

  void deleteScriptModel(String name) {
    if (!scriptModelMap.containsKey(name)) return;
    scriptModelMap.remove(name);
    wsService.close(name);
    autoScriptList.removeWhere((e) => e == name);
  }

  ScriptModel? findScriptModel(String name) {
    return scriptModelMap[name];
  }

  bool isRunning(String scriptName) {
    return scriptModelMap.containsKey(scriptName) &&
        scriptModelMap[scriptName]!.state.value == ScriptState.running;
  }

  // 自动启动脚本
  Future<void> autoRunScript() async {
    if (autoScriptList.isEmpty) return;
    final scriptList = List.of(autoScriptList);
    final psController = Get.put<ProgressSnackbarController>(
        ProgressSnackbarController(titleText: I18n.auto_run_script.tr));
    psController.show();
    // 最少启动4s用来等待模拟器等其他初始化
    const minDelay = Duration(seconds: 4);
    final successScriptList = <String>[];
    for (final scriptName in scriptList) {
      bool success = false;
      if (isRunning(scriptName)) {
        success = true;
      } else {
        startScript(scriptName);
        double progress = 0.0;
        final taskStartTime = DateTime.now();
        success = await TimeoutUtils.runWithTimeout(
          period: const Duration(milliseconds: 30),
          timeout: const Duration(seconds: 6),
          check: () => _checkStartSuccess(scriptName, taskStartTime, minDelay),
          onTick: () {
            if (progress + 0.005 >= 1) return;
            psController.updateMessage(scriptName);
            psController.updateProgress(progress += 0.005);
          },
        );
        psController.updateProgress(success ? 1 : 0);
      }
      if (success) successScriptList.add(scriptName);
    }
    psController.updateMessage('$successScriptList ${I18n.start_success.tr}');
  }

  bool _checkStartSuccess(
      String scriptName, DateTime taskStartTime, Duration minDelay) {
    final isRun =
        scriptModelMap[scriptName]!.state.value == ScriptState.running;
    final elapsedSinceStart = DateTime.now().difference(taskStartTime);
    final timeArrived = elapsedSinceStart >= minDelay;
    return isRun && timeArrived;
  }

  void updateAutoScript(String script, bool? isSelected) {
    if (isSelected == null) return;
    if (isSelected) {
      autoScriptList.add(script);
    } else {
      autoScriptList.remove(script);
    }
    autoScriptList.sort();
    _storage.write(StorageKey.autoScriptList.name, jsonEncode(autoScriptList));
  }
}
