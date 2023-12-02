import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class GithubVersionModel extends BaseNetModel {
  @override
  GithubVersionModel fromJson(Map<String, dynamic> json) {
    return GithubVersionModel.fromJson(json);
  }

  GithubVersionModel({
    this.version,
    this.body,
  });
  GithubVersionModel.fromJson(dynamic json) {
    version = json['tag_name'];
    body = json['body'];
  }

  String? version;
  String? body;
}

// 对版本进行对比，如果last > current 则返回true
bool compareVersion(String current, String last) {
  if (current.contains('v')) {
    current = current.substring(1);
  }
  if (last.contains('v')) {
    last = last.substring(1);
  }
  List<String> currentNumbers = current.split('.');
  List<String> lastNumbers = last.split('.');
  if (int.parse(currentNumbers[0]) < int.parse(lastNumbers[0])) {
    return true;
  }
  if (int.parse(currentNumbers[1]) < int.parse(lastNumbers[1])) {
    return true;
  }
  if (int.parse(currentNumbers[2]) < int.parse(lastNumbers[2])) {
    return true;
  }
  return false;
}

Future<String> getCurrentVersion() async {
  if (kReleaseMode) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
  return 'v0.0.0';
}

void showUpdateVersion(String content) {
  Get.dialog(Markdown(data: content));
}
