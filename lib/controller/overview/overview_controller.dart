part of overview;

enum ScriptState {
  inactive, // 0
  running, // 递增
  warning,
  updating,
}

class OverviewController extends GetxController with LogMixin {
  WebSocketChannel? channel;
  int wsConnetCount = 0;
  bool _shouldReconnect = true;

  String name;
  var scriptState = ScriptState.updating.obs;
  final running = const TaskItemModel('', '').obs;
  final pendings = <TaskItemModel>[].obs;
  final waitings = const <TaskItemModel>[].obs;

  @override
  int get maxLines => 300;

  OverviewController({required this.name});

  @override
  Future<void> onReady() async {
    await wsConnect();
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    await wsClose(WebSocketStatus.normalClosure, 'script $name normal close');
    super.onClose();
  }

  void toggleScript() {
    if (scriptState.value != ScriptState.running) {
      scriptState.value = ScriptState.running;
      channel!.sink.add('start');
      clearLog();
    } else {
      scriptState.value = ScriptState.inactive;
      channel!.sink.add('stop');
    }
  }

  Future<void> wsConnect() async {
    try {
      String address = 'ws://${ApiClient().address}/ws/$name';
      if (address.contains('http://')) {
        address = address.replaceAll('http://', '');
      }
      printInfo(info: address);
      channel = WebSocketChannel.connect(Uri.parse(address));
    } on SocketException {
      printInfo(
          info:
          'Unhandled Exception: SocketException: Failed host lookup: http (OS Error: 不知道这样的主机。');
    } on Exception catch (e) {
      printError(info: e.toString());
    }
    await channel!.ready;
    channel!.stream.listen(wsListen, onDone: wsReconnect);
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

  void wsReconnect() {
    // not reconnect if custom close
    if (!_shouldReconnect) {
      printInfo(info: "WebSocket closed intentionally, no reconnect");
      return;
    }
    wsConnetCount += 1;
    if (wsConnetCount > 10) {
      printError(info: "WebSocket reconnect failed");
      printError(info: "WebSocket is closed");
      printError(info: 'WebSocket reconnect is more than 10 times');
      return;
    }
    printInfo(info: "Socket is closed");
    wsConnect();
  }

  Future<void> wsClose(int code, String closeReason, {bool reconnect = false}) async {
    _shouldReconnect = reconnect;
    await channel!.sink.close(code, closeReason);
  }

}
