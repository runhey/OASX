library appbar;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

class DesktopAppbar extends StatelessWidget {
  const DesktopAppbar({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: WindowCaption(
        brightness: Get.theme.brightness,
        title: _title(),
      ),
    );
  }

  Widget _title() {
    return <Widget>[
      Image.asset("assets/images/Icon-app.png"),
      const Text("OASX"),
      const Text("free"),
    ].toRow();
  }
}
