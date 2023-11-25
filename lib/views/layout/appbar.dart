import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/layout/title.dart';

PreferredSizeWidget windowAppbar() {
  return PreferredSize(
    // preferredSize: const Size.fromHeight(kWindowCaptionHeight),
    preferredSize: const Size.fromHeight(50),
    child: WindowCaption(
      brightness: Get.theme.brightness,
      title: getTitle(),
    ),
  );
}

// windows 的比较特殊
PreferredSizeWidget desktopAppbar() {
  return AppBar(title: getTitle());
}

PreferredSizeWidget mobileTabletAppbar() {
  return AppBar(title: getTitle());
}
