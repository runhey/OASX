import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import 'package:oasx/views/args/args_view.dart';
import 'package:oasx/views/home/home_view.dart';
import 'package:oasx/views/home/tool_view.dart';
import 'package:oasx/views/home/updater_view.dart';
import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/overview/overview_view.dart';

Widget content() {
  return GetX<NavCtrl>(builder: (controller) {
    return switch ([
      controller.selectedScript.value,
      controller.selectedMenu.value
    ]) {
      ['Home', 'Home'] => const HomeView(),
      // ignore: prefer_const_constructors, unused_local_variable
      [String name, 'Overview'] => Overview(),
      _ => const Args(),
    };
  });
}
