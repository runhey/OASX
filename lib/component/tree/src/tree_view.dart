import 'package:flutter/material.dart';

import 'package:oasx/component/tree/src/tree_node.dart';

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
