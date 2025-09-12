part of nav;

class TreeMenuView extends StatelessWidget {
  const TreeMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NavCtrl>(builder: (controller) {
      Map<String, List<String>> data = controller.isHomeMenu.value
          ? controller.homeMenuJson
          : controller.scriptMenuJson;
      return ScreenTypeLayout.builder(
          mobile: (_) => _mobile(controller, data, context),
          tablet: (_) => _mobile(controller, data, context),
          desktop: (_) => _desktop(controller, data));
    });
  }

  Widget _desktop(NavCtrl controller, Map<String, List<String>> data) {
    return TreeView(
            data: data,
            onTap: (e) {
              controller.switchContent(e);
            })
        .constrained(width: 180)
        .alignment(Alignment.topLeft)
        .card(margin: const EdgeInsets.all(0))
        .padding(bottom: 10);
  }

  Widget _mobile(NavCtrl controller, Map<String, List<String>> data,
      BuildContext context) {
    return TreeView(
            data: data,
            onTap: (e) {
              controller.switchContent(e);
            })
        .constrained(width: 180)
        .alignment(Alignment.topLeft)
        .padding(top: 30)
        .decorated(color: Theme.of(context).scaffoldBackgroundColor);
  }
}
