import 'package:flutter/material.dart';

import '../tree_menu.dart';

class TreeNode extends StatefulWidget {
  final TreeNodeData data;
  final TreeNodeData parent;
  final State? parentState;

  final bool lazy;
  final Widget icon;
  final bool showCheckBox;
  final bool showActions;
  final bool contentTappable;
  final double offsetLeft;
  final int? maxLines;

  final Function(TreeNodeData node) onTap;
  final void Function(bool checked, TreeNodeData node) onCheck;

  final void Function(TreeNodeData node) onExpand;
  final void Function(TreeNodeData node) onCollapse;

  final Future Function(TreeNodeData node) load;
  final void Function(TreeNodeData node) onLoad;

  final void Function(TreeNodeData node) remove;
  final void Function(TreeNodeData node, TreeNodeData parent) onRemove;

  final void Function(TreeNodeData node) append;
  final void Function(TreeNodeData node, TreeNodeData parent) onAppend;

  const TreeNode({
    Key? key,
    required this.data,
    required this.parent,
    this.parentState,
    required this.offsetLeft,
    this.maxLines,
    required this.showCheckBox,
    required this.showActions,
    required this.contentTappable,
    required this.icon,
    required this.lazy,
    required this.load,
    required this.append,
    required this.remove,
    required this.onTap,
    required this.onCheck,
    required this.onLoad,
    required this.onExpand,
    required this.onAppend,
    required this.onRemove,
    required this.onCollapse,
  }) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isChecked = false;
  bool _showLoading = false;
  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);

  List<TreeNode> _geneTreeNodes(List list) {
    return List.generate(list.length, (int index) {
      return TreeNode(
        data: list[index],
        parent: widget.data,
        parentState: widget.parentState != null ? this : null,
        remove: widget.remove,
        append: widget.append,
        icon: widget.icon,
        lazy: widget.lazy,
        load: widget.load,
        offsetLeft: widget.offsetLeft,
        maxLines: widget.maxLines,
        showCheckBox: widget.showCheckBox,
        showActions: widget.showActions,
        contentTappable: widget.contentTappable,
        onTap: widget.onTap,
        onCheck: widget.onCheck,
        onExpand: widget.onExpand,
        onLoad: widget.onLoad,
        onCollapse: widget.onCollapse,
        onRemove: widget.onRemove,
        onAppend: widget.onAppend,
      );
    });
  }

  @override
  initState() {
    super.initState();
    _isExpanded = widget.data.expanded;
    _isChecked = widget.data.checked;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onExpand(widget.data);
        } else if (status == AnimationStatus.reverse) {
          widget.onCollapse(widget.data);
        }
      });
    if (_isExpanded) {
      _rotationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parentState != null) _isChecked = widget.data.checked;

    bool hasData =
        widget.data.children.isNotEmpty || (widget.lazy && !_isExpanded);

    // bool selected = TreeView.selectedNode == widget.data.title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// 水波纹
        InkWell(
          splashColor: widget.contentTappable ? null : Colors.transparent,
          highlightColor: widget.contentTappable ? null : Colors.transparent,
          mouseCursor: widget.contentTappable
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          onTap: widget.contentTappable
              ? () {
                  if (hasData) {
                    widget.onTap(widget.data);
                    toggleExpansion();
                  } else {
                    _isChecked = !_isChecked;
                    widget.onCheck(_isChecked, widget.data);

                    /// 设置高亮
                    if (TreeView.selectedNode != widget.data.title) {
                      TreeView.selectedNode = widget.data.title;
                      widget.onTap(widget.data);
                    }
                    setState(() {});
                  }
                }
              : () {},
          child: Container(
            height: 40,
            // margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.only(right: 12.0),

            /// 灰色 200的颜色
            // color: selected ? Colors.grey[200] : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// 这个是左边的拓展图标
                if (hasData)
                  SizedBox(
                    width: 40,
                    child: RotationTransition(
                      turns: _turnsTween.animate(_rotationController),
                      child: IconButton(
                        iconSize: 16,
                        icon: hasData ? widget.icon : Container(),
                        onPressed: hasData
                            ? () {
                                // widget.onTap(widget.data);
                                toggleExpansion();
                              }
                            : null,
                      ),
                    ),
                  ),

                /// 勾选框
                if (widget.showCheckBox)
                  Checkbox(
                    value: _isChecked,
                    checkColor: widget.data.checkBoxCheckColor,
                    fillColor: widget.data.checkBoxFillColor,
                    onChanged: (bool? value) {
                      _isChecked = value!;
                      if (widget.parentState != null) _checkUncheckParent();
                      widget.onCheck(_isChecked, widget.data);
                      setState(() {});
                    },
                  ),

                /// 懒加载图片
                if (widget.lazy && _showLoading)
                  const SizedBox(
                    width: 12.0,
                    height: 12.0,
                    child: CircularProgressIndicator(strokeWidth: 1.0),
                  ),

                /// 文字
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        !hasData ? const EdgeInsets.only(left: 10.0) : null,
                    key: ValueKey(widget.data.backgroundColor?.call()),
                    color: widget.data.backgroundColor?.call(),
                    child: Text(
                      widget.data.title,
                      textAlign: TextAlign.center,
                      maxLines: widget.maxLines ?? 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                if (widget.showActions)
                  TextButton(
                    onPressed: () {
                      widget.append(widget.data);
                      widget.onAppend(widget.data, widget.parent);
                    },
                    child: const Text('Add', style: TextStyle(fontSize: 12.0)),
                  ),
                if (widget.showActions)
                  TextButton(
                    onPressed: () {
                      widget.remove(widget.data);
                      widget.onRemove(widget.data, widget.parent);
                    },
                    child:
                        const Text('Remove', style: TextStyle(fontSize: 12.0)),
                  ),
                if (widget.data.customActions?.isNotEmpty == true)
                  ...widget.data.customActions!,
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _rotationController,
          child: Padding(
            padding: EdgeInsets.only(left: widget.offsetLeft),
            child: Column(children: _geneTreeNodes(widget.data.children)),
          ),
        )
      ],
    );
  }

  void toggleExpansion() {
    if (widget.lazy && widget.data.children.isEmpty) {
      setState(() {
        _showLoading = true;
      });
      widget.load(widget.data).then((value) {
        if (value) {
          _isExpanded = true;
          _rotationController.forward();
          widget.onLoad(widget.data);
        }
        _showLoading = false;
        setState(() {});
      });
    } else {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
      setState(() {});
    }
  }

  void _checkUncheckParent() {
    // Check/uncheck all children based on parent state
    widget.data.checked = _isChecked;
    widget.data.children.forEach((child) => child.checked = _isChecked);
    widget.parentState!.setState(() {});

    // Check/uncheck parent based on children state
    widget.parent.checked = widget.parent.children.every((e) => e.checked);
    widget.parentState!.setState(() {});
  }
}
