part of overview;

class TaskItemModel {
  final taskName = ''.obs;
  final nextRun = ''.obs;

  TaskItemModel(taskName, nextRun) {
    this.taskName.value = taskName;
    this.nextRun.value = nextRun;
  }

  static TaskItemModel empty() {
    return TaskItemModel('', '');
  }

  bool isAllEmpty() {
    return taskName.isEmpty && nextRun.isEmpty;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskItemModel &&
          runtimeType == other.runtimeType &&
          taskName == other.taskName &&
          nextRun == other.nextRun;

  @override
  int get hashCode => Object.hash(taskName, nextRun);
}
