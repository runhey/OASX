import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:oasx/views/layout/title.dart';
import 'package:oasx/views/overview/overview_view.dart';
import 'package:oasx/views/home/home_view.dart';

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

  Widget content() {
    return GetX<NavCtrl>(builder: (controller) {
      return switch ([
        controller.selectedScript.value,
        controller.selectedMenu.value
      ]) {
        // ignore: prefer_const_constructors
        ['Home', 'Home'] => HomeView(),
        // ignore: prefer_const_constructors, unused_local_variable
        [String name, 'Overview'] => Overview(),
        _ => const Args(),
      };
    });
  }
}
