import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/views/layout/appbar.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/layout/content.dart';
import 'package:styled_widget/styled_widget.dart';

class MobileLayoutView extends StatelessWidget {
  const MobileLayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbar = switch (Theme.of(context).platform) {
      TargetPlatform.android => mobileTabletAppbar(),
      TargetPlatform.iOS => mobileTabletAppbar(),
      TargetPlatform.windows => mobileWindowsAppbar(),
      _ => mobileTabletAppbar(),
    };
    return Scaffold(
      appBar: appbar,
      drawer: drawer(),
      body: body(),
    );
  }

  Widget body() {
    return content().center();
  }

  Widget drawer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Nav(),
        TreeMenuView(),
      ],
    );
  }
}
