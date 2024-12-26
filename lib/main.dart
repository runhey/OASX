import 'dart:io';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/routes.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:oasx/controller/settings.dart';
import 'package:oasx/comom/i18n.dart';
import 'package:oasx/config/theme.dart' show lightTheme, darkTheme;

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformUtils.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode && (PlatformUtils.isWindows),
      builder: (context) => const OASXApp(), // Wrap your app
    ),
  );
}

class OASXApp extends StatelessWidget {
  const OASXApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (context) {
      return GetMaterialApp(
        // useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        // locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder, // 上面三个是使用device_preview
        scrollBehavior: GlobalBehavior(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        fallbackLocale: const Locale('zh', 'CN'), //语言选择无效时，备用语言
        title: 'OASX',
        onInit: onInit,
        initialRoute: Routes.initial,
        getPages: Routes.routes,
        theme: lightTheme,
        darkTheme: darkTheme,
      );
    });
  }

  /// 但是我不能确定 Getx 框架这个时候是否成功初始化
  void onInit() {
    Get.put(SettingsController());
  }
}

class GlobalBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
