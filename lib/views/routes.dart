import 'package:get/get.dart';

import 'package:oasx/views/layout/layout.dart';
import 'package:oasx/views/layout/binding.dart';
import 'package:oasx/views/login/login_view.dart';
import 'package:oasx/views/settings/settings_view.dart';
import 'package:oasx/views/server/server_view.dart';

class Routes {
  /// when the app is opened, this page will be the first to be shown
  static const initial = '/login';

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
    GetPage(
      name: '/settings',
      page: () => SettingsView(),
    ),
    GetPage(
      name: '/server',
      page: () => const ServerView(),
      binding: BindingsBuilder(() {
        Get.put<ServerController>(ServerController());
      }),
    ),
  ];
}
