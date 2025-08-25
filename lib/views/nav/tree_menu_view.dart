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
      final isDesktop = switch (Theme.of(context).platform) {
        TargetPlatform.windows => true,
        TargetPlatform.linux => true,
        TargetPlatform.macOS => true,
        TargetPlatform.android => false,
        TargetPlatform.iOS => false,
        _ => false,
      };
      if (isDesktop) {
        return TreeView(
                data: data,
                onTap: (e) {
                  controller.switchContent(e);
                })
            .constrained(width: 180)
            .alignment(Alignment.topLeft)
            .card(margin: const EdgeInsets.all(0));
      } else {
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
    });
  }
}
