// 菜单模型
import 'package:flutter/material.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart';

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
}
