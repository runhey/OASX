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
            _actionButtons(context), // 改为渲染多个按钮的容器
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

  // 新增：封装两个按钮（立即运行 + 任务设置）
  Widget _actionButtons(BuildContext context) {
    return <Widget>[
      // 1. 立即运行按钮
      Tooltip(
        message: I18n.task_pin_top.tr,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // 可自定义按钮颜色（如需匹配主题，用 Theme.of(context).primaryColor）
          ),
          // 立即运行按钮点击事件：将此任务的下一次运行时间设置为当前时间
          onPressed: () async {
            try {
              // 获取当前脚本名称
              final scriptName = Get.find<NavCtrl>().selectedScript.value;
              print("scriptName: $scriptName");
              // 格式化当前时间为 "YYYY-MM-DD HH:mm:ss" 格式
              final now = DateTime.now();
              final year = now.year.toString();
              final month = now.month.toString().padLeft(2, '0');
              final day = now.day.toString().padLeft(2, '0');
              final hour = now.hour.toString().padLeft(2, '0');
              final minute = now.minute.toString().padLeft(2, '0');
              final second = now.second.toString().padLeft(2, '0');
              final currentTime = '$year-$month-$day $hour:$minute:$second';

              // 更新任务的 next_run 时间为当前时间
              final success = await ApiClient().putScriptArg(
                scriptName,
                model.taskName,
                'scheduler',
                'next_run',
                'string',
                currentTime,
              );

              if (success) {
                print("${model.taskName} 的下一次运行时间已更新为: $currentTime");
                // 显示成功通知
                Get.snackbar(I18n.task_pin_top.tr, '${model.taskName} ${I18n.task_next_run_updated_to.tr}: $currentTime',
                    duration: const Duration(seconds: 1));
                // 刷新任务状态
                Get.find<ScriptService>().wsService.send(scriptName, 'get_state');
              } else {
                print("更新 ${model.taskName} 的下一次运行时间失败");
                // 显示失败通知
                Get.snackbar(I18n.operation_failed.tr, I18n.update_task_next_run_failed.tr,
                    duration: const Duration(seconds: 1));
              }
            } catch (e) {
              print("更新任务运行时间时出错: $e");
              // 显示错误通知
              Get.snackbar(I18n.operation_failed.tr, '${I18n.update_task_run_time_error.tr}: $e',
                  duration: const Duration(seconds: 2));
            }
          },
          child: Text(
            '▲', // 'I18n.run_now.tr', // 新增国际化key："立即运行"（需在I18n文件中添加）
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
          ),
        ),
      ).constrained(maxWidth: 30, maxHeight: 30),

      const SizedBox(width: 5), // 按钮之间的间距

      // 2. 延迟运行按钮：将下次运行时间设置为1年后的今天
      Tooltip(
        message: I18n.task_pin_bottom.tr,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () async {
            try {
              // 获取当前脚本名称
              final scriptName = Get.find<NavCtrl>().selectedScript.value;
              
              // 计算1年后的今天
              final now = DateTime.now();
              final oneYearLater = DateTime(now.year + 1, now.month, now.day, now.hour, now.minute, now.second);
              
              // 格式化为 "YYYY-MM-DD HH:mm:ss" 格式
              final year = oneYearLater.year.toString();
              final month = oneYearLater.month.toString().padLeft(2, '0');
              final day = oneYearLater.day.toString().padLeft(2, '0');
              final hour = oneYearLater.hour.toString().padLeft(2, '0');
              final minute = oneYearLater.minute.toString().padLeft(2, '0');
              final second = oneYearLater.second.toString().padLeft(2, '0');
              final oneYearLaterTime = '$year-$month-$day $hour:$minute:$second';

              // 更新任务的 next_run 时间为1年后的今天
              final success = await ApiClient().putScriptArg(
                scriptName,
                model.taskName,
                'scheduler',
                'next_run',
                'string',
                oneYearLaterTime,
              );

              if (success) {
                print("${model.taskName} 的下一次运行时间已更新为: $oneYearLaterTime");
                // 显示成功通知
                Get.snackbar(I18n.task_pin_bottom.tr, '${model.taskName} ${I18n.task_next_run_updated_to.tr}: $oneYearLaterTime',
                    duration: const Duration(seconds: 1));
                // 刷新任务状态
                Get.find<ScriptService>().wsService.send(scriptName, 'get_state');
              } else {
                print("更新 ${model.taskName} 的下一次运行时间失败");
                // 显示失败通知
                Get.snackbar(I18n.operation_failed.tr, I18n.update_task_next_run_failed.tr,
                    duration: const Duration(seconds: 1));
              }
            } catch (e) {
              print("更新任务运行时间时出错: $e");
              // 显示错误通知
              Get.snackbar(I18n.operation_failed.tr, '${I18n.update_task_run_time_error.tr}: $e',
                  duration: const Duration(seconds: 2));
            }
          },
          child: Text(
            '▼',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
          ),
        ),
      ).constrained(maxWidth: 30, maxHeight: 30),

      const SizedBox(width: 5), // 按钮之间的间距

      // 3. 原有的任务设置按钮（保持不变）
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () => Get.find<NavCtrl>().switchContent(model.taskName),
        child: Text(
          I18n.task_setting.tr,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ).constrained(maxWidth: 100, maxHeight: 30),
    ].toRow(mainAxisAlignment: MainAxisAlignment.end); // 按钮右对齐
  }
}
