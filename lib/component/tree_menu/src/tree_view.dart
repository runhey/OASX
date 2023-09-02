import 'package:flutter/material.dart';

import './tree_node.dart';
import './tree_node_data.dart';

class TreeView extends StatefulWidget {
  final List<TreeNodeData> data;

  final bool lazy;
  final Widget icon;
  final double offsetLeft;
  final int? maxLines;
  final bool showFilter;
  final String filterPlaceholder;
  final bool showActions;
  final bool showCheckBox;
  final bool contentTappable;

  /// Desired behavior:
  /// - if I check/uncheck a parent I want all children to be checked/unchecked
  /// - if I check/uncheck all children I want the parent to be checked/unchecked
  final bool manageParentState;
  static String selectedNode = 'OverView';

  final void Function(TreeNodeData node)? onTap;
  final void Function(TreeNodeData node)? onLoad;
  final void Function(TreeNodeData node)? onExpand;
  final void Function(TreeNodeData node)? onCollapse;
  final void Function(bool checked, TreeNodeData node)? onCheck;
  final void Function(TreeNodeData node, TreeNodeData parent)? onAppend;
  final void Function(TreeNodeData node, TreeNodeData parent)? onRemove;
  final void Function(String title)? onSelected;

  final TreeNodeData Function(TreeNodeData parent)? append;
  final Future<List<TreeNodeData>> Function(TreeNodeData parent)? load;

  const TreeView({
    Key? key,
    required this.data,
    this.onTap,
    this.onCheck,
    this.onLoad,
    this.onExpand,
    this.onCollapse,
    this.onAppend,
    this.onRemove,
    this.onSelected,
    this.append,
    this.load,
    this.lazy = false,
    this.offsetLeft = 24.0,
    this.maxLines,
    this.showFilter = false,
    this.filterPlaceholder = 'Search',
    this.showActions = false,
    this.showCheckBox = false,
    this.contentTappable = false,
    this.icon = const Icon(Icons.expand_more, size: 16.0),
    this.manageParentState = false,
  }) : super(key: key);

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late TreeNodeData _root;
  List<TreeNodeData> _renderList = [];

  List<TreeNodeData> _filter(String val, List<TreeNodeData> list) {
    List<TreeNodeData> tempNodes = [];

    for (int i = 0; i < list.length; i++) {
      TreeNodeData tempNode = TreeNodeData.from(list[i]);

      if (tempNode.children.isNotEmpty) {
        tempNode.children = _filter(val, tempNode.children);
      }

      if (tempNode.title.contains(RegExp(val, caseSensitive: false)) ||
          tempNode.children.isNotEmpty) {
        tempNodes.add(tempNode);
      }
    }

    return tempNodes;
  }

  void _onChange(String val) {
    _renderList = widget.data;

    if (val.isNotEmpty) {
      _renderList = _filter(val, _renderList);
    }

    setState(() {});
  }

  void append(TreeNodeData parent) {
    parent.children.add(widget.append!(parent));
    setState(() {});
  }

  void _remove(TreeNodeData node, List<TreeNodeData> list) {
    for (int i = 0; i < list.length; i++) {
      if (node == list[i]) {
        list.removeAt(i);
      } else {
        _remove(node, list[i].children);
      }
    }
  }

  void remove(TreeNodeData node) {
    _remove(node, _renderList);
    setState(() {});
  }

  Future<bool> load(TreeNodeData node) async {
    try {
      final data = await widget.load!(node);
      node.children = data;
      setState(() {});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _renderList = widget.data;
    _root = TreeNodeData(
      title: '',
      extra: null,
      checked: false,
      expanded: false,
      children: _renderList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                bottom: 12.0,
              ),
              child: TextField(
                  onChanged: _onChange,
                  decoration: InputDecoration(
                    labelText: widget.filterPlaceholder,
                  )),
            ),
          ...List.generate(
            _renderList.length,
            (int index) {
              return TreeNode(
                load: load,
                remove: remove,
                append: append,
                parent: _root,
                parentState: widget.manageParentState ? this : null,
                data: _renderList[index],
                icon: widget.icon,
                lazy: widget.lazy,
                offsetLeft: widget.offsetLeft,
                maxLines: widget.maxLines,
                showCheckBox: widget.showCheckBox,
                showActions: widget.showActions,
                contentTappable: widget.contentTappable,
                onTap: widget.onTap ?? (n) {},
                onLoad: widget.onLoad ?? (n) {},
                onCheck: widget.onCheck ?? (b, n) {},
                onExpand: widget.onExpand ?? (n) {},
                onRemove: widget.onRemove ?? (n, p) {},
                onAppend: widget.onAppend ?? (n, p) {},
                onCollapse: widget.onCollapse ?? (n) {},
              );
            },
          )
        ],
      ),
    );
  }
}
