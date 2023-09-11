import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:get/get.dart';

class DesktopAppbar extends AppBar {
  DesktopAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      toolbarHeight: 50,
      title: const Text("OASX"),
    );
  }
}
