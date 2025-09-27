part of overview;

class OverviewController extends GetxController with LogMixin {
  String name;
  final scriptService = Get.find<ScriptService>();
  late final scriptModel = scriptService.findScriptModel(name)!;

  @override
  int get maxLines => 300;

  OverviewController({required this.name});

  @override
  void onInit() {
    ever(scriptModel.runningLogs, (logs) {
      if (logs.isNotEmpty) {
        addLog(logs.last);
      }
    });
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    // close log
    super.onClose();
  }

  Future<void> toggleScript() async {
    if (scriptModel.state.value != ScriptState.running) {
      scriptService.runScript(name);
      clearLog();
    } else {
      scriptService.stopScript(name);
    }
  }
}
