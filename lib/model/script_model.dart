import 'package:get/get.dart';
import 'package:oasx/views/overview/overview_view.dart';

enum ScriptState {
  inactive,
  running,
  warning,
  updating,;

  static ScriptState getState(dynamic value){
    return switch (value) {
      0 => inactive,
      1 => running,
      2 => warning,
      3 => updating,
      _ => inactive,
    };
  }
}

class ScriptModel {
  String name;
  final state = ScriptState.updating.obs;
  final runningTask = const TaskItemModel('', '').obs;
  final pendingTaskList = <TaskItemModel>[].obs;
  final waitingTaskList = <TaskItemModel>[].obs;
  final runningLogs = <String>[].obs;

  ScriptModel(this.name);

  void update(
      {ScriptState? state,
      TaskItemModel? runningTask,
      List<TaskItemModel>? pendingTaskList,
      List<TaskItemModel>? waitingTaskList,
      List<String>? runningLogs}) {
    if (state != null && this.state.value != state) this.state.value = state;
    if (runningTask != null && this.runningTask.value != runningTask) {
      this.runningTask.value = runningTask;
    }
    if (pendingTaskList != null) this.pendingTaskList.value = pendingTaskList;
    if (waitingTaskList != null) this.waitingTaskList.value = waitingTaskList;
    if (runningLogs != null) this.runningLogs.value = runningLogs;
  }

  void appendLog(String log) {
    runningLogs.add(log);
  }

  void clearLog() {
    runningLogs.clear();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state.toJson(),
        'runningTask': runningTask.toJson(),
        'pendingTaskList': pendingTaskList.toJson(),
        'waitingTaskList': waitingTaskList.toJson()
      };
}
