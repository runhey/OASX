import 'package:flutter/material.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:oasx/views/layout/desktop.dart';
import 'package:oasx/views/layout/mobile.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.platfrom();

    // 桌面平台固定走 DesktopLayout
    if (platform == PlatformType.windows ||
        platform == PlatformType.macOS ||
        platform == PlatformType.linux) {
      return const DesktopLayoutView();
    }

    // 移动 & Web 根据屏幕宽度走自适应
    return ScreenTypeLayout.builder(
      mobile: (_) => const MobileLayoutView(),
      tablet: (_) => const MobileLayoutView(),
      desktop: (_) => const DesktopLayoutView(),
    );
  }
}
