library nav_menu;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/controller/settings.dart';
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
        printInfo(info: '现在重建menu');
        NavCtrl navCtroller = Get.find<NavCtrl>();
        //var data = if(controller.isHomeMenu.value){return controller.homeData}else{ return controller.scriptData};
        var data = controller.isHomeMenu.value
            ? controller.homeModel.toTreeData()
            : controller.scriptModel.toTreeData();

        if (controller.isHomeMenu.value) {
          return TreeView(
            offsetLeft: 30,
            // icon: const Icon(Icons.arrow_right),
            data: data,
            contentTappable: false,
            onTap: (node) => {navCtroller.switchContent(node.title)},
          );
        } else {
          return TreeView(
            offsetLeft: 30,
            // icon: const Icon(Icons.arrow_right),
            data: data,
            contentTappable: false,
            onTap: (node) => {navCtroller.switchContent(node.title)},
          );
        }
      },
    );
  }
}
