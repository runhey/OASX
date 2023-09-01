import 'package:get/get.dart';

import 'package:oasx/views/nav/view_nav.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavCtrl());
  }
}
