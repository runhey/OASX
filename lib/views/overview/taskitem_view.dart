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
        _name(context),
        _action(context),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .padding(bottom: 10);
    }
  }

  Widget _name(BuildContext context) {
    return <Widget>[
      Text(taskName.tr, style: Theme.of(context).textTheme.labelLarge),
      Text(nextRun, style: Theme.of(context).textTheme.labelMedium)
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _action(BuildContext context) {
    return OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              NavCtrl navCtrl = Get.find();
              navCtrl.switchContent(taskName);
            },
            child: Text(I18n.task_setting.tr, style: Theme.of(context).textTheme.bodySmall))
        .constrained(maxWidth: 100, maxHeight: 30);
  }
}
