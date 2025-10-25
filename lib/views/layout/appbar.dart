import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/layout/title.dart';
import 'package:oasx/utils/platform_utils.dart';

//
// -----------------------------------------------------------------------------
PreferredSizeWidget buildPlatformAppBar(
  BuildContext context, {
  bool isCollapsed = false,
}) {
  final platform = PlatformUtils.platfrom();
  return switch (platform) {
    PlatformType.windows => _windowAppbar(
        context,
        isCollapsed: isCollapsed,
      ),
    PlatformType.linux => _desktopAppbar(),
    PlatformType.macOS => _desktopAppbar(),
    PlatformType.android => _mobileTabletAppbar(),
    PlatformType.iOS => _mobileTabletAppbar(),
    PlatformType.web => _webAppbar(),
    _ => _webAppbar(),
  };
}

PreferredSizeWidget _windowAppbar(BuildContext context, {bool? isCollapsed}) {
  return PreferredSize(
    // preferredSize: const Size.fromHeight(kWindowCaptionHeight),
    preferredSize: const Size.fromHeight(50),
    child: WindowCaption(
      brightness: Get.theme.brightness,
      backgroundColor: Colors.transparent,
      title: <Widget>[
        if (isCollapsed == true)
          Builder(builder: (builderContext) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => {Scaffold.of(builderContext).openDrawer()},
            );
          }),
        getTitle()
      ].toRow(),
    ),
  );
}

PreferredSizeWidget _desktopAppbar() {
  return AppBar(title: getTitle());
}

PreferredSizeWidget _webAppbar() {
  return AppBar(
    title: getTitle(),
    backgroundColor: Colors.transparent,
  );
}

PreferredSizeWidget _mobileTabletAppbar() {
  return AppBar(title: getTitle());
}
