part of overview;

enum ScriptState {
  inactive, // 0
  running, // 递增
  warning,
  updating,
}

class OverviewController extends GetxController with LogMixin {
  String name;
  var scriptState = ScriptState.updating.obs;
  final running = const TaskItemModel('', '').obs;
  final pendings = <TaskItemModel>[].obs;
  final waitings = const <TaskItemModel>[].obs;
  final wsService = Get.find<WebSocketService>();

  @override
  int get maxLines => 300;

  OverviewController({required this.name});

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
    super.onClose();
  }

  void toggleScript() {
    if (scriptState.value != ScriptState.running) {
      scriptState.value = ScriptState.running;
      wsService.send(name, 'start');
      clearLog();
    } else {
      scriptState.value = ScriptState.inactive;
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
      if (scriptState.value != newState) {
        scriptState.value = newState;
      }
    } else if (data.containsKey('schedule')) {
      Map run = data['schedule']['running'];
      List<dynamic> pending = data['schedule']['pending'];

      List<dynamic> waiting = data['schedule']['waiting'];

      if (run.isNotEmpty) {
        running.value = TaskItemModel(run['name'], run['next_run']);
      } else {
        running.value = const TaskItemModel('', '');
      }
      pendings.value = [];
      for (var element in pending) {
        pendings.add(TaskItemModel(element['name'], element['next_run']));
      }
      waitings.value = [];
      for (var element in waiting) {
        waitings.add(TaskItemModel(element['name'], element['next_run']));
      }
    }
  }
}
