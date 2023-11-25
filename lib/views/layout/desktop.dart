import 'package:flutter/material.dart';
import 'package:oasx/views/layout/appbar.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/layout/content.dart';

class DesktopLayoutView extends StatelessWidget {
  const DesktopLayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbar = switch (Theme.of(context).platform) {
      TargetPlatform.windows => windowAppbar(),
      TargetPlatform.linux => desktopAppbar(),
      TargetPlatform.macOS => desktopAppbar(),
      _ => desktopAppbar(),
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
