import 'dart:convert';

import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/component/dialog/progress_dialog.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/service/websocket_service.dart';
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
    ever(scriptModelMap, (_) {
      autoScriptList.removeWhere((e) => !scriptModelMap.containsKey(e));
    });
    super.onInit();
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
    await wsService.connect(name: name, listener: (mg) => wsListener(mg, name));
  }

  Future<void> startScript(String name) async {
    await connectScript(name);
    await wsService.send(name, 'start');
    await wsService.send(name, 'get_state');
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
          ? TaskItemModel(run['name'], run['next_run'])
          : TaskItemModel.empty();
      final pendingList =
          pending.map((e) => TaskItemModel(e['name'], e['next_run'])).toList();
      final waitingList =
          waiting.map((e) => TaskItemModel(e['name'], e['next_run'])).toList();
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
  }

  ScriptModel? findScriptModel(String name) {
    return scriptModelMap[name];
  }

  Future<void> autoRunScript() async {
    if (autoScriptList.isEmpty) {
      return;
    }
    ProgressDialog.show('Auto-start script detected', autoScriptList);
    for (final scriptName in List.of(autoScriptList)) {
      runScript(scriptName);
      double progress = 0.0;
      final success = await TimeoutUtils.runWithTimeout(
        period: const Duration(milliseconds: 100),
        timeout: const Duration(seconds: 5),
        check: () =>
            scriptModelMap[scriptName]!.state.value == ScriptState.running,
        onTick: () {
          if (progress + 0.02 < 1) {
            ProgressDialog.update(scriptName, progress += 0.02);
          }
        },
      );
      if (!success) {
        ProgressDialog.update(scriptName, 0);
      } else {
        ProgressDialog.update(scriptName, 1);
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    ProgressDialog.setConfirm();
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
