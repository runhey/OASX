import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:window_manager/window_manager.dart';

class WindowService extends GetxService with WindowListener {
  final _storage = GetStorage();

  Future<WindowService> init() async {
    if (!PlatformUtils.isDesktop) return this;
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
    windowManager.addListener(this);
    return this;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
