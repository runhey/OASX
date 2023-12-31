import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:oasx/views/layout/desktop.dart';
import 'package:oasx/views/layout/mobile.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const MobileLayoutView(),
      tablet: (_) => const MobileLayoutView(),
      desktop: (_) => const DesktopLayoutView(),
    );
  }
}
