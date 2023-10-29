library nav;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';
import 'package:oasx/views/overview/overview_view.dart';
import 'package:styled_widget/styled_widget.dart';

part '../../controller/ctrl_nav.dart';

class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final NavCtrl controller = Get.find();

    return GetX<NavCtrl>(builder: (controller) {
      return NavigationRail(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (value) => {controller.switchScript(value)},
        labelType: NavigationRailLabelType.all, // 就是是否显示文字
        // elevation: 20, // 影深度
        useIndicator: true, // 指示器
        trailing: _trailing(),
        minWidth: 48,
        destinations: controller.scriptName
            .map((element) => NavigationRailDestination(
                icon: element == 'Home'
                    ? const Icon(Icons.home_rounded)
                    : const Icon(Icons.play_circle),
                label: Text(element)))
            .toList(),
      );
    });
  }

  // List<NavigationRailDestination> _destinations() {
  //   return <NavigationRailDestination>[
  //     const NavigationRailDestination(
  //       icon: Icon(Icons.home_rounded),
  //       label: Text('Home'),
  //     ),
  //     const NavigationRailDestination(
  //       icon: Icon(Icons.play_circle),
  //       label: Text('First'),
  //     ),
  //     const NavigationRailDestination(
  //       icon: Icon(Icons.play_circle),
  //       label: Text('Second'),
  //     ),
  //     const NavigationRailDestination(
  //       icon: Icon(Icons.play_circle),
  //       label: Text('Three'),
  //     ),
  //   ];
  // }

  Widget _trailing() {
    // NavCtrl controllerNav = Get.find<NavCtrl>();
    // SettingsController controllerSetting = Get.find<SettingsController>();
    return <Widget>[
      IconButton(icon: const Icon(Icons.add), onPressed: () {}),
      // _DarkMode(onPressed: controllerSetting.updateTheme),
      IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Get.toNamed('/settings');
          }),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.end)
        .padding(bottom: 10)
        .expanded();
  }
}
