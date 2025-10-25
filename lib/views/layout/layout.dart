import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:oasx/views/layout/desktop.dart';
import 'package:oasx/views/layout/mobile.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 屏幕类型是屏幕类型，平台是平台类型
    // 先是屏幕类型，再是平台类型
    return ScreenTypeLayout.builder(
      mobile: (_) => const MobileLayoutView(),
      tablet: (_) => const MobileLayoutView(),
      desktop: (_) => const DesktopLayoutView(),
    );
  }
}
