part of overview;

enum ScriptState {
  inactive, // 0
  running, // 递增
  warning,
  updating,
}

class OverviewController extends GetxController {
  WebSocketChannel? channel;

  String name;
  var scriptState = ScriptState.updating.obs;
  final running = const TaskItemModel('', '').obs;
  final pendings = <TaskItemModel>[
    const TaskItemModel('pandings1', 'nextrun'),
    const TaskItemModel('pandings2', 'nextrun'),
    const TaskItemModel('pandings3', 'nextrun'),
    const TaskItemModel('pandings4', 'nextrun')
  ].obs;
  final waitings = const <TaskItemModel>[
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings4', 'nextrun')
  ].obs;

  final log = r'''
═══════════════════════════════════════════════════════════════════════════════════
                                       START                                       
═══════════════════════════════════════════════════════════════════════════════════
INFO     13:35:25.792 │ [Task] Restart (Enable, 2020-01-01 00:00:00)               
INFO     13:35:25.794 │ Bind task {'Alas', 'Restart', 'General'}                   
═════════════════════════════════════ DEVICE ══════════════════════════════════════
INFO     13:35:28.450 │ DEVICE                                                     
INFO     13:35:28.452 │ [IS_ON_PHONE_CLOUD] False                                  
INFO     13:35:28.453 │ [AdbBinary] E:\Project\AzurLaneAutoScript\toolkit\Lib\site-
         packages\adbutils\binaries\adb.exe                                        
INFO     13:35:28.457 │ [AdbClient] AdbClient(127.0.0.1, 5037)                     
INFO     13:35:28.459 │ <<< DETECT DEVICE >>>                                      
INFO     13:35:28.460 │ Here are the available devices, copy to                    
         Alas.Emulator.Serial to use it or set Alas.Emulator.Serial="auto"         
INFO     13:35:28.463 │ No available devices                                       
CRITICAL 13:35:28.465 │ No available device found, auto device detection cannot    
         work, please set an exact serial in Alas.Emulator.Serial instead of using 
         "auto"           ""'''
      .obs;

  // Timer? testTimer;
  // int count = 0;

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
    channel!.stream.listen(listen);
    super.onReady();
  }

  void activeScript() {
    if (scriptState.value != ScriptState.running) {
      scriptState.value = ScriptState.running;
      channel!.sink.add('start');
    } else {
      scriptState.value = ScriptState.inactive;
      channel!.sink.add('stop');
    }
  }

  void listen(dynamic message) {
    printInfo(info: message.toString());
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

  void addLog(String message) {}
}
