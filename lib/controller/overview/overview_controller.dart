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

  Future<void> onMoveToPending(TaskItemModel model) async {
    final nextRun = formatDateTime(DateTime.now());
    final success = await ApiClient().putScriptArg(name, model.taskName.value,
        'scheduler', 'next_run', 'date_time', nextRun);
    if (!success) return;
    if (scriptModel.runningTask.value == model) {
      scriptModel.runningTask.value = TaskItemModel.empty();
    } else {
      scriptModel.waitingTaskList
          .removeWhere((e) => e.taskName == model.taskName);
    }
    model.nextRun.value = nextRun;
    scriptModel.pendingTaskList.add(model);
  }

  Future<void> onMoveToWaiting(TaskItemModel model) async {
    final nextRun =
        formatDateTime(DateTime.now().add(const Duration(days: 1)));
    final success = await ApiClient().putScriptArg(name, model.taskName.value,
        'scheduler', 'next_run', 'date_time', nextRun);
    if (!success) return;
    if (scriptModel.runningTask.value == model) {
      scriptModel.runningTask.value = TaskItemModel.empty();
    } else {
      scriptModel.pendingTaskList
          .removeWhere((e) => e.taskName == model.taskName);
    }
    model.nextRun.value = nextRun;
    scriptModel.waitingTaskList.add(model);
  }
}
