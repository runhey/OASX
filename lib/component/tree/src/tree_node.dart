import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

// 第一级 节点
class TreeNode1 extends StatefulWidget {
  final String title;
  final void Function(String title)? onTap;
  final List<String> children;

  const TreeNode1(
      {super.key,
      required this.title,
      required this.onTap,
      required this.children});

  @override
  TreeNode1State createState() => TreeNode1State();
}

class TreeNode1State extends State<TreeNode1> {
  // 判断是否没有后续节点
  bool get _isLeaf {
    return widget.children.isEmpty || widget.children == [];
  }

  // 判断是否已经打开
  bool _isExpanded = false;

  // 鼠标是否在这个区域内
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    Icon icon = _isExpanded
        ? const Icon(Icons.expand_more)
        : const Icon(Icons.chevron_right);
    Text title = _isHover
        ? Text(widget.title.tr, style: const TextStyle(color: Colors.blue))
        : Text(widget.title.tr);
    return Column(
      children: [
        MouseRegion(
                // 鼠标进入的时候 高亮
                onEnter: (event) {
                  setState(() {
                    _isHover = true;
                  });
                },
                // 鼠标离开的时候 正常
                onExit: (event) {
                  setState(() {
                    _isHover = false;
                  });
                },
                child: _isLeaf
                    ? TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(left: 20)),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: onPressed,
                        child: title)
                    : TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: onPressed,
                        icon: icon,
                        label: title))
            // .alignment(Alignment.centerLeft)
            .constrained(width: 180)
            .alignment(Alignment.topLeft),
        if (_isExpanded && !_isLeaf)
          Column(
            children: widget.children
                .map((e) => TreeNode1(
                      title: e,
                      onTap: widget.onTap,
                      children: const [],
                    ))
                .toList(),
          ),
      ],
    );
  }

  void Function()? onPressed() {
    widget.onTap!(widget.title);
    setState(() {
      _isExpanded = !_isExpanded;
    });
    return null;
  }
}

// 第二级 节点 ------------------------------------------------------------------
// class TreeNode2 extends StatefulWidget {
//   final String title;
//   final void Function(String title)? onTap;

//   const TreeNode2({super.key, required this.title, required this.onTap});

//   @override
//   TreeNode2State createState() => TreeNode2State();
// }

// class TreeNode2State extends State<TreeNode1> {
//   @override
//   Widget build(BuildContext context) {}
// }
