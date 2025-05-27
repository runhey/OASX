import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/layout/title.dart';

PreferredSizeWidget windowAppbar() {
  return PreferredSize(
    // preferredSize: const Size.fromHeight(kWindowCaptionHeight),
    preferredSize: const Size.fromHeight(50),
    child: WindowCaption(
      brightness: Get.theme.brightness,
      backgroundColor: Colors.transparent,
      title: getTitle(),
    ),
  );
}

// windows 的比较特殊
PreferredSizeWidget desktopAppbar() {
  return AppBar(title: getTitle());
}

PreferredSizeWidget webAppbar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(90),
    child: getTitle().padding(left: 16, top: 10, bottom: 10),
  );
}

PreferredSizeWidget mobileTabletAppbar() {
  return AppBar(title: getTitle());
}

PreferredSizeWidget mobileWindowsAppbar(){
  return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: DragToMoveArea(
          child: AppBar(title: getTitle())
      )
  );
}