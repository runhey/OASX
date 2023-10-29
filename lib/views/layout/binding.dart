import 'package:get/get.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:oasx/views/overview/overview_view.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(fenix: true, () => NavCtrl()); // 全局唯一的
    // Get.lazyPut(fenix: true, () => NavMenuController()); // 全局唯一的
    Get.put<NavCtrl>(permanent: true, NavCtrl()); // 全局唯一的
    Get.put<NavMenuController>(permanent: true, NavMenuController()); // 全局唯一的
    Get.lazyPut(fenix: true, () => ArgsController()); // 全局唯一的
  }
}
