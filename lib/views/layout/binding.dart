import 'package:get/get.dart';
import 'package:oasx/service/script_service.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/args/args_view.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NavCtrl>(permanent: true, NavCtrl()); // 全局唯一的
    Get.lazyPut(fenix: true, () => ArgsController()); // 全局唯一的
    Get.putAsync(() async => ScriptService());
  }
}
