part of overview;

enum ScriptState {
  inactive, // 0
  running, // 递增
  warning,
  updating,
}

class OverviewController extends GetxController {
  WebSocketChannel? channel;
  int wsConnetCount = 0;

  String name;
  var scriptState = ScriptState.updating.obs;
  final running = const TaskItemModel('', '').obs;
  final pendings = <TaskItemModel>[].obs;
  final waitings = const <TaskItemModel>[].obs;

  // final log = ''.obs;
  // 修改log声明为可维护行数的结构
  final log = <String>[].obs; // 改为存储每行日志的列表

  final scrollController = ScrollController();
  final autoScroll = true.obs;


  OverviewController({required this.name});

  @override
  void onInit() {
    // testTimer = Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) => {
    //     log.value += 'INFO     13:35:28.463 │ No available devices\n',
    //     count += 1,
    //     if (count >= 20)
    //       {
    //         testTimer?.cancel(),
    //       }
    //   },
    // );
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await wsConnet();
    super.onReady();
  }

  void activeScript() {
    if (scriptState.value != ScriptState.running) {
      scriptState.value = ScriptState.running;
      channel!.sink.add('start');
      clearLog();
    } else {
      scriptState.value = ScriptState.inactive;
      channel!.sink.add('stop');
    }
  }

  Future<void> wsConnet() async {
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
    channel!.stream.listen(wsListen, onDone: wsReconnet);
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
      scriptState.value = switch (data['state']) {
        0 => ScriptState.inactive,
        1 => ScriptState.running,
        2 => ScriptState.warning,
        3 => ScriptState.updating,
        _ => ScriptState.inactive,
      };
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

  void wsReconnet() {
    wsConnetCount += 1;
    if (wsConnetCount > 10) {
      printError(info: "WebSocket reconnect failed");
      printError(info: "WebSocket is closed");
      printError(info: 'WebSocket reconnect is more than 10 times');
      return;
    }
    printInfo(info: "Socket is closed");
    wsConnet();
  }

  // void addLog(String message) {
  //   log.value += message;
  // }
  //
  // void clearLog() {
  //   log.value = '';
  // }


  // 在OverviewController中保持原有addLog方法
  void addLog(String message) {
    final lines = message.replaceAll('\r\n', ''); // 处理含换行符的消息
    log.add(lines);

    if (log.length > 2000) {
      // log.removeRange(0, log.length - 2000);
      log.removeRange(0, 1500);
    }

    if (autoScroll.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void clearLog() {
    log.clear();
  }


}
