part of overview;

class TaskItemView extends StatelessWidget {
  final TaskItemModel model;
  const TaskItemView(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return model.isAllEmpty()
        ? const SizedBox(height: 30)
        : <Widget>[
      _name(context),
      _action(context),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(bottom: 10);
  }

  Widget _name(BuildContext context) {
    return <Widget>[
      Text(model.taskName.tr, style: Theme.of(context).textTheme.labelLarge),
      Text(model.nextRun, style: Theme.of(context).textTheme.labelMedium)
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
        onPressed: () => Get.find<NavCtrl>().switchContent(model.taskName),
        child: Text(I18n.task_setting.tr,
            style: Theme.of(context).textTheme.bodySmall))
        .constrained(maxWidth: 100, maxHeight: 30);
  }
}
