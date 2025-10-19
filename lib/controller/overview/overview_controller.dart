part of overview;

class OverviewController extends GetxController with LogMixin {
  String name;
  final scriptService = Get.find<ScriptService>();
  late final scriptModel = scriptService.findScriptModel(name)!;
  final isWaitingLoading = false.obs;
  final isPendingLoading = false.obs;

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

  Future<void> onMoveToPending(TaskItemModel model) async {
    isPendingLoading.value = true;
    final nextRun =
        formatDateTime(DateTime.now().subtract(const Duration(days: 1)));
    final argsController = Get.find<ArgsController>();
    await argsController.updateScriptTask(name, model.taskName.value, true);
    await argsController.updateScriptTaskNextRun(
        name, model.taskName.value, nextRun);
    isPendingLoading.value = false;
  }

  Future<void> onMoveToWaiting(TaskItemModel model) async {
    isWaitingLoading.value = true;
    await Get.find<ArgsController>()
        .updateScriptTask(name, model.taskName.value, true);
    await ApiClient().syncNextRun(name, model.taskName.value);
    isWaitingLoading.value = false;
  }

  Future<bool> disableScriptTask(TaskItemModel model) async {
    final ret = await Get.find<ArgsController>()
        .updateScriptTask(model.scriptName, model.taskName.value, false);
    return ret;
  }
}
