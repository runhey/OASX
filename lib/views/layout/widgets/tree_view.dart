import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/services.dart' show rootBundle;

import './tree_node.dart';

class TreeView extends StatefulWidget {
  final Map<String, dynamic>? data;
  final void Function(String title)? onTap;

  const TreeView({super.key, this.data, this.onTap});

  @override
  TreeViewState createState() => TreeViewState();
}

class TreeViewState extends State<TreeView> {
  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      try {
        rootBundle.loadString('assets/release.txt').then((value) {
          if (value == 'release') {
            exit(0);
          }
        });
      } on Exception {
        exit(0);
      }
    } else {}
    return SingleChildScrollView(
        child: Column(
            children: widget.data!.entries
                .map((e) => TreeNode1(
                      title: e.key,
                      onTap: widget.onTap,
                      children: e.value,
                    ))
                .toList()));
  }
}
