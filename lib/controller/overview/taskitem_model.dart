part of overview;

class TaskItemModel {
  final String taskName;
  final String nextRun;

  const TaskItemModel(this.taskName, this.nextRun);

  static TaskItemModel empty(){
    return const TaskItemModel('', '');
  }

  bool isAllEmpty(){
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
