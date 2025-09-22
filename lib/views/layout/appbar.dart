import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/layout/title.dart';
import 'package:oasx/utils/platform_utils.dart';

/// 统一入口：根据平台返回合适的 AppBar
PreferredSizeWidget buildPlatformAppBar(BuildContext context, {
  bool isCollapsed = false,
  VoidCallback? onMenuPressed,
}) {
  final platform = PlatformUtils.platfrom();
  return switch (platform) {
    PlatformType.windows => _windowAppbar(
      context,
      onMenuPressed: isCollapsed ? onMenuPressed : null,
    ),
    PlatformType.linux => _desktopAppbar(),
    PlatformType.macOS => _desktopAppbar(),
    PlatformType.android => _mobileTabletAppbar(),
    PlatformType.iOS => _mobileTabletAppbar(),
    PlatformType.web => _webAppbar(),
    _ => _webAppbar(),
  };
}

/// 配置：哪些页面不显示返回按钮
final Set<String> noBackButtonRoutes = {
  '/home', // 首页不要返回按钮
  '/login', // 登录页也不要返回按钮
};

/// 判断当前路由是否应该显示返回按钮
bool _shouldShowBack() {
  final current = Get.currentRoute;
  return !noBackButtonRoutes.contains(current);
}

/// Windows 特殊标题栏
PreferredSizeWidget _windowAppbar(BuildContext context, {VoidCallback? onMenuPressed}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: WindowCaption(
      brightness: Theme.of(context).brightness,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          if (onMenuPressed != null)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuPressed,
            ),
          getTitle(),
        ],
      ),
    ),
  );
}

/// 桌面 (Linux / macOS)
PreferredSizeWidget _desktopAppbar() {
  return AppBar(
    title: getTitle(),
    automaticallyImplyLeading: _shouldShowBack(),
  );
}

/// Web
PreferredSizeWidget _webAppbar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(90),
    child: getTitle().padding(left: 16, top: 10, bottom: 10),
  );
}

/// 移动端 (Android / iOS)
PreferredSizeWidget _mobileTabletAppbar() {
  return AppBar(
    title: getTitle(),
    automaticallyImplyLeading: _shouldShowBack(),
  );
}
