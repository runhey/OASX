// 菜单模型
import 'package:flutter/material.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart';

import 'package:oasx/component/tree_menu/tree_menu.dart';

class ScriptMenuModel extends BaseNetModel {
  // List<dynamic>? menuList;
  Map<String, List<String>>? data;
  ScriptMenuModel({required this.data});

  ScriptMenuModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      data = <String, List<String>>{};
      return;
    }
    data = <String, List<String>>{};
    json.forEach((key, value) {
      data![key] = value.cast<String>();
    });
  }

  @override
  ScriptMenuModel fromJson(Map<String, dynamic> json) {
    return ScriptMenuModel.fromJson(json);
  }

  List<TreeNodeData> toTreeData() {
    return data!.entries.map((entry) {
      return TreeNodeData(
          extra: entry.value,
          title: entry.key,
          checked: true,
          expanded: false,
          children: entry.value.length > 1
              ? entry.value
                  .map((e) => TreeNodeData(
                      title: e, checked: true, expanded: false, children: []))
                  .toList()
              : []);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return data!;
  }
}
