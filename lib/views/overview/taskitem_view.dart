part of overview;

class TaskItemView extends StatelessWidget {
  final String taskName;
  final String nextRun;

  const TaskItemView(this.taskName, this.nextRun, {super.key});

  TaskItemView.fromModel(TaskItemModel model, {super.key})
      : taskName = model.taskName,
        nextRun = model.nextRun;

  @override
  Widget build(BuildContext context) {
    if (taskName == '' && nextRun == '') {
      return const SizedBox(height: 30);
    } else {
      return <Widget>[
        _name(),
        _action(),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .padding(bottom: 10);
    }
  }

  Widget _name() {
    return <Widget>[
      Text(taskName.tr, style: Get.textTheme.labelLarge),
      Text(nextRun, style: Get.textTheme.labelMedium)
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _action() {
    return OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () => {},
            child: Text('Setting', style: Get.textTheme.bodySmall))
        .constrained(maxWidth: 100, maxHeight: 30);
  }
}
