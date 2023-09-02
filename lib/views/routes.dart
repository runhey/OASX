import 'package:get/get.dart';

import 'package:oasx/views/layout/layout.dart';
import 'package:oasx/views/layout/binding.dart';
import 'package:oasx/views/login/login_view.dart';

class Routes {
  /// when the app is opened, this page will be the first to be shown
  static const initial = '/main';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => const LayoutView(),
      binding: LayoutBinding(),
    ),
  ];
}
