library nav;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/controller/settings.dart';
part '../../controller/ctrl_nav.dart';

class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final NavCtrl controller = Get.find();

    return GetX<NavCtrl>(builder: (controller) {
      return NavigationRail(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (value) =>
            {controller.selectedIndex.value = value},
        labelType: NavigationRailLabelType.all, // 就是是否显示文字
        // elevation: 20, // 影深度
        useIndicator: true, // 指示器
        trailing: _trailing(),
        minWidth: 48,
        destinations: _destinations(),
      );
    });
  }

  List<NavigationRailDestination> _destinations() {
    return <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(Icons.home_rounded),
        label: Text('Home'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.play_circle),
        label: Text('First'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.play_circle),
        label: Text('Second'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.play_circle),
        label: Text('Three'),
      ),
    ];
  }

  Widget _trailing() {
    // NavCtrl controllerNav = Get.find<NavCtrl>();
    SettingsController controllerSetting = Get.find<SettingsController>();
    return <Widget>[
      IconButton(icon: const Icon(Icons.add), onPressed: () {}),
      _DarkMode(onPressed: controllerSetting.updateTheme),
      IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.end)
        .padding(bottom: 10)
        .expanded();
  }
}

class _DarkMode extends StatefulWidget {
  const _DarkMode({
    required this.onPressed,
  });
  final void Function(Color?, bool?) onPressed;

  @override
  _DarkModeState createState() => _DarkModeState();
}

class _DarkModeState extends State<_DarkMode> {
  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        setState(() {
          isDark = !isDark;
          widget.onPressed(null, isDark);
        }),
      },
      icon: const Icon(Icons.light_mode),
      selectedIcon: const Icon(Icons.dark_mode),
      isSelected: isDark,
    );
  }
}
