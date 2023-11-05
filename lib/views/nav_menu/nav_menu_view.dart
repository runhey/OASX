library nav_menu;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/component/tree_menu/tree_menu.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/api/menu_model.dart';
import 'package:oasx/views/nav/view_nav.dart';

part '../../controller/nav_menu/nav_menu_controller.dart';

class NavMenuView extends StatelessWidget {
  const NavMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NavMenuController>(
      builder: (controller) {
        NavCtrl navCtroller = Get.find<NavCtrl>();
        return TreeView(
          offsetLeft: 30,
          // icon: const Icon(Icons.arrow_right),
          data: controller.treeData.value,
          contentTappable: true,
          onTap: (node) => {navCtroller.switchContent(node.title)},
        );
      },
    );
  }
}
