part of overview;

class TaskItemView extends StatelessWidget {
  final TaskItemModel model;
  final String source; // 来源
  final bool enableDrag; // 是否允许拖拽

  const TaskItemView(
    this.model, {
    super.key,
    required this.source,
    this.enableDrag = true,
  });

  @override
  Widget build(BuildContext context) {
    if (model.isAllEmpty()) return const SizedBox(height: 30);

    // 如果禁用拖拽，直接返回内容
    if (!enableDrag) {
      return _buildContent(context);
    }

    return LongPressDraggable<Map<String, dynamic>>(
      data: {'model': model, 'source': source},
      feedback: _buildFeedback(context),
      child: _buildContent(context),
    );
  }

  /// 拖动时，跟随手指移动的反馈组件
  Widget _buildFeedback(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Material(
      color: Colors.transparent,
      child: Text(model.taskName.value.tr,
              style: Theme.of(context).textTheme.titleMedium)
          .decorated(
            color: themeService.isDarkMode
                ? Colors.blueGrey.shade700
                : Colors.blueGrey.shade100,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          )
          .width(150)
          .height(30)
          .paddingAll(8)
          .opacity(0.8),
    );
  }

  /// 普通状态下显示内容
  Widget _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.transparent, // 保留可点击区域
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _name(context),
          _action(context),
        ],
      ),
    );
  }

  Widget _name(BuildContext context) {
    return <Widget>[
      Text(model.taskName.value.tr,
          style: Theme.of(context).textTheme.labelLarge),
      Obx(() {
        return Text(model.nextRun.value,
            style: Theme.of(context).textTheme.labelMedium);
      })
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
            onPressed: () =>
                Get.find<NavCtrl>().switchContent(model.taskName.value),
            child: Text(I18n.task_setting.tr,
                style: Theme.of(context).textTheme.bodySmall))
        .constrained(maxWidth: 100, maxHeight: 30);
  }
}
