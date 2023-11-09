import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:oasx/views/overview/overview_view.dart';
import 'package:oasx/views/home/home_view.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  @override
  Widget build(BuildContext context) {
    return const Text("Content View");
  }
}
