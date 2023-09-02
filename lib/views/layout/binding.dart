import 'package:get/get.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavCtrl());
    Get.lazyPut(() => NavMenuController());
  }
}
