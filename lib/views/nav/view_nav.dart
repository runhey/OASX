library nav;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/controller/settings.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:treemenu2/treemenu2.dart';

import 'package:oasx/views/overview/overview_view.dart';
import 'package:oasx/api/api_client.dart';

part '../../controller/ctrl_nav.dart';
part './tree_menu_view.dart';

class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // 保证至少占满屏幕高度，但如果内容更高就让它自适应
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: _navigationRail(),
            ),
          ),
        );
      },
    );
  }

  List<NavigationRailDestination> _destinations(List<String> names) {
    if (names.length == 1) {
      return [
        NavigationRailDestination(
            icon: const Icon(Icons.home_rounded),
            label: Text(
              'Home'.tr,
            )),
        NavigationRailDestination(
            icon: const Icon(Icons.home_rounded), label: Text('oas1'.tr))
      ];
    } else {
      return names
          .map((element) => NavigationRailDestination(
              icon: element == 'Home'
                  ? const Icon(Icons.home_rounded)
                  : const Icon(Icons.play_circle),
              label: Text(
                element.tr,
                style: Get.textTheme.labelMedium,
              )))
          .toList();
    }
  }

  Widget _navigationRail() {
    return GetX<NavCtrl>(builder: (controller) {
      return NavigationRail(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (value) => {controller.switchScript(value)},
        labelType: NavigationRailLabelType.all, // 就是是否显示文字
        // elevation: 20, // 影深度
        useIndicator: true, // 指示器
        trailing: _trailing(),
        minWidth: 48,
        destinations: _destinations(controller.scriptName),
      );
    });
  }

  Widget _trailing() {
    return <Widget>[
      IconButton(icon: const Icon(Icons.add), onPressed: addButton),
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

  Future<void> addButton() async {
    String newName = await ApiClient().getNewConfigName();
    String template = 'template';
    List<String> configAll = await ApiClient().getConfigAll();
    NavCtrl controllerNav = Get.find<NavCtrl>();
    Get.defaultDialog(
        title: 'Add New Config',
        middleText: '',
        onConfirm: () async {
          controllerNav.scriptName.value =
              await ApiClient().configCopy(newName, template);
        },
        content: <Widget>[
          const Text('New name'),
          TextFormField(
              initialValue: newName,
              onChanged: (value) {
                newName = value;
              }).constrained(width: 200),
          const Text('Copy from existing config'),
          DropdownButton<String>(
            value: template,
            items: configAll
                .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                    value: e.toString(),
                    child: Text(
                      e.toString(),
                      style: Get.textTheme.bodyLarge,
                    ).constrained(width: 177)))
                .toList(),
            onChanged: (value) {
              template = value.toString();
            },
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start));
  }
}
