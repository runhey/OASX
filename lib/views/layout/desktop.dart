import 'package:flutter/material.dart';
import 'package:oasx/views/layout/appbar.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/layout/content.dart';
import 'package:oasx/utils/platform_utils.dart';

class DesktopLayoutView extends StatelessWidget {
  const DesktopLayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbar = switch (PlatformUtils.platfrom()) {
      PlatformType.windows => windowAppbar(),
      PlatformType.linux => desktopAppbar(),
      PlatformType.macOS => desktopAppbar(),
      PlatformType.android => mobileTabletAppbar(),
      PlatformType.iOS => mobileTabletAppbar(),
      PlatformType.web => webAppbar(),
      _ => webAppbar(),
    };
    return Scaffold(
      appBar: appbar,
      body: body(),
    );
  }

  Widget body() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Nav(),
        TreeMenuView(),
        Expanded(
          child: Center(child: content()),
        )
      ],
    );
  }
}
