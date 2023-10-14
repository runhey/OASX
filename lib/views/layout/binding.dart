import 'package:get/get.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:oasx/views/overview/overview_view.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavCtrl());
    Get.lazyPut(() => NavMenuController());
    Get.lazyPut(() => ArgsController());
    Get.lazyPut(() => OverviewController());
  }
}
