part of overview;

class _SchedulerWidget extends StatelessWidget {
  const _SchedulerWidget({
    required this.controller,
  });

  final OverviewController controller;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.scheduler.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      <Widget>[
        Obx(() {
          return switch (controller.scriptModel.state.value) {
            ScriptState.running => const SpinKitChasingDots(
                color: Colors.green,
                size: 22,
              ),
            ScriptState.inactive =>
              const Icon(Icons.donut_large, size: 26, color: Colors.grey),
            ScriptState.warning =>
              const SpinKitDoubleBounce(color: Colors.orange, size: 26),
            ScriptState.updating => const Icon(Icons.browser_updated_rounded,
                size: 26, color: Colors.blue),
          };
        }),
        Obx(() {
          return IconButton(
            onPressed: () => {controller.toggleScript()},
            icon: const Icon(Icons.power_settings_new_rounded),
            isSelected:
                controller.scriptModel.state.value == ScriptState.running,
          );
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center)
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .constrained(height: 48)
        .paddingOnly(left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }
}
