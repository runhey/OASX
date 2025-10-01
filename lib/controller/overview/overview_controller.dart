part of overview;

class OverviewController extends GetxController with LogMixin {
  String name;
  final scriptService = Get.find<ScriptService>();
  late final scriptModel = scriptService.findScriptModel(name)!;

  OverviewController({required this.name});

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    // close log
    super.onClose();
  }

  Future<void> toggleScript() async {
    if (scriptModel.state.value != ScriptState.running) {
      scriptService.startScript(name);
      clearLog();
    } else {
      scriptService.stopScript(name);
    }
  }
}
