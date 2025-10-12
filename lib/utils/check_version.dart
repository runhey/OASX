import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/config/constants.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return 'v${packageInfo.version}';
  }
  return 'v0.0.1';
}

void showUpdateVersion(String content) {
  Get.dialog(Markdown(data: content));
}

Future<void> checkUpdate({bool showTip = false}) async {
  if (!kReleaseMode) {
    return;
  }
  GithubVersionModel githubVersionModel = await ApiClient().getGithubVersion();
  String currentVersion = await getCurrentVersion();
  String githubVersion = githubVersionModel.version ?? 'v0.0.0';
  debugPrint('currentVersion: $currentVersion, githubVersion: $githubVersion');
  String githubUpdateInfo = githubVersionModel.body ?? 'Something wrong';
  Widget goOasxRelease = TextButton(
      onPressed: () async => {await launchUrl(Uri.parse(oasxRelease))},
      child: Text(I18n.go_oasx_release.tr));
  if (compareVersion(currentVersion, githubVersion)) {
    Widget dialog = SingleChildScrollView(
            child: <Widget>[
      Text('${I18n.latest_version.tr}: $githubVersion'),
      Text('${I18n.current_version.tr}: $currentVersion'),
      goOasxRelease,
      MarkdownBody(data: githubUpdateInfo),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start))
        .constrained(height: 300, width: 300);
    Get.defaultDialog(title: I18n.find_new_version.tr, content: dialog);
    return;
  }
  if (showTip) Get.snackbar(I18n.tip.tr, I18n.no_new_version.tr);
}
