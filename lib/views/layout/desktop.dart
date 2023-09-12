import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:oasx/views/layout/title.dart';

class DesktopLayoutView extends StatelessWidget {
  const DesktopLayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _windowAppBar(),
      body: body(),
    );
  }

  Widget body() {
    return Row(
      children: <Widget>[
        const Nav(),
        // const VerticalDivider(thickness: 1, width: 1),
        Container(
          alignment: Alignment.topLeft,
          width: 180,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
            color: Get.theme.colorScheme.surfaceVariant,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: const NavMenuView(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        //Expanded 占满剩下屏幕空间

        const Expanded(
          child: Center(child: Args()),
        )
      ],
    );
  }

  PreferredSizeWidget appbar() {
    return AppBar(
      backgroundColor: Get.theme.colorScheme.background,
      toolbarHeight: 50,
      title: const Text("OASX"),
    );
  }

  PreferredSizeWidget _windowAppBar() {
    return PreferredSize(
      // preferredSize: const Size.fromHeight(kWindowCaptionHeight),
      preferredSize: const Size.fromHeight(50),
      child: WindowCaption(
        brightness: Get.theme.brightness,
        title: const TitleBar(),
      ),
    );
  }
}
