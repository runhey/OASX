part of overview;

class OverviewController extends GetxController {
  var scriptState = ScriptState.updating.obs;
  final running = const TaskItemModel('taksname', 'nextrun').obs;
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

  Timer? testTimer;
  int count = 0;

  @override
  void onInit() {
    testTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => {
        log.value += 'INFO     13:35:28.463 │ No available devices\n',
        count += 1,
        if (count >= 20)
          {
            testTimer?.cancel(),
          }
      },
    );
    super.onInit();
  }

  void activeScript() {
    if (scriptState.value != ScriptState.running) {
      scriptState.value = ScriptState.running;
    } else {
      scriptState.value = ScriptState.inactive;
    }
  }
}

enum ScriptState {
  running,
  inactive,
  warning,
  updating,
}
