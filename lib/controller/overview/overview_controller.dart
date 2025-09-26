part of overview;

class OverviewController extends GetxController with LogMixin {
  WebSocketChannel? channel;

  String name;
  final wsService = Get.find<WebSocketService>();
  late final scriptModel = ScriptModel(name);

  @override
  int get maxLines => 300;

  OverviewController({required this.name});

  @override
  void onInit() {
    Get.find<ScriptService>().addOrUpdateScriptModel(scriptModel);
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await wsService
        .connect(name: name, listener: wsListen)
        .send("get_state")
        .send("get_schedule");
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    await wsService.close(
      name,
      reason: "script $name normal close",
    );
    Get.find<ScriptService>().deleteScriptModel(name);
    super.onClose();
  }

  Future<void> toggleScript() async {
    if (scriptModel.state.value != ScriptState.running) {
      scriptModel.state.value = ScriptState.running;
      wsService.send(name, 'start');
      clearLog();
    } else {
      scriptModel.state.value = ScriptState.inactive;
      wsService.send(name, 'stop');
    }
  }

  void wsListen(dynamic message) {
    if (message is! String) {
      printError(info: 'Websocket push data is not of type string and map');
      return;
    }
    if (!message.startsWith('{') || !message.endsWith('}')) {
      addLog(message);
      return;
    }
    Map<String, dynamic> data = json.decode(message);
    if (data.containsKey('state')) {
      final newState = switch (data['state']) {
        0 => ScriptState.inactive,
        1 => ScriptState.running,
        2 => ScriptState.warning,
        3 => ScriptState.updating,
        _ => ScriptState.inactive,
      };
      if (scriptModel.state.value != newState) {
        scriptModel.state.value = newState;
      }
    } else if (data.containsKey('schedule')) {
      Map run = data['schedule']['running'];
      List<dynamic> pending = data['schedule']['pending'];
      List<dynamic> waiting = data['schedule']['waiting'];
      TaskItemModel runningTask = run.isNotEmpty
          ? TaskItemModel(run['name'], run['next_run'])
          : const TaskItemModel('', '');
      final pendingList =
          pending.map((e) => TaskItemModel(e['name'], e['next_run'])).toList();
      final waitingList =
          waiting.map((e) => TaskItemModel(e['name'], e['next_run'])).toList();
      scriptModel.update(
          runningTask: runningTask,
          pendingTaskList: pendingList,
          waitingTaskList: waitingList);
    }
  }
}
