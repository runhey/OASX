import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart' hide MarkdownWidget;
import 'package:markdown_widget/markdown_widget.dart' show MarkdownWidget;
import 'package:url_launcher/url_launcher.dart';

import 'package:oasx/api/api_client.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/api/home_model.dart';
import 'package:oasx/config/github_readme.dart' show githubReadme;
import 'package:oasx/config/constants.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //延时执行的代码
      checkUpdate().then((value) => null);
    });

    return FutureBuilder<ReadmeGithubModel>(
        future: ApiClient().getGithubReadme(),
        builder:
            (BuildContext context, AsyncSnapshot<ReadmeGithubModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 当Future还未完成时，显示加载中的UI
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // 当Future发生错误时，显示错误提示的UI
            return Text('Error: ${snapshot.error}');
          } else {
            // 当Future成功完成时，显示数据
            String content = snapshot.data?.content ?? githubReadme;
            return MarkdownWidget(data: content).paddingAll(10);
          }
        });
  }

  Future<void> checkUpdate() async {
    if (!kReleaseMode) {
      return;
    }
    GithubVersionModel githubVersionModel =
        await ApiClient().getGithubVersion();
    String currentVersion = await getCurrentVersion();
    String githubVersion = githubVersionModel.version ?? 'v0.0.0';
    printInfo(info: 'Github Version: $githubVersion');
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
    }
  }
}
