part of nav;

class TreeMenuView extends StatelessWidget {
  TreeMenuView({Key? key}) : super(key: key);

  final Map<String, List<String>> test3 = {'Home': [], 'Updater': []};
  final Map<String, List<String>> test4 = {
    'Overview': ['Script', 'Restart']
  };

  @override
  Widget build(BuildContext context) {
    return GetX<NavCtrl>(builder: (controller) {
      Map<String, List<String>> data = controller.isHomeMenu.value
          ? controller.homeMenuJson
          : controller.scriptMenuJson;
      return TreeView(
              data: data,
              onTap: (e) {
                controller.switchContent(e);
              })
          .constrained(width: 180)
          .alignment(Alignment.topLeft)
          .card(margin: const EdgeInsets.all(0))
          .padding(bottom: 10);
    });
  }
}
