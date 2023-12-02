import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:oasx/api/api_client.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/comom/i18n_content.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      //延时执行的代码
      checkUpdate().then((value) => null);
    });
    return const Markdown(data: '# v0')
        .constrained(maxHeight: 500, maxWidth: 500);
  }

  Future<void> checkUpdate() async {
    if (!kReleaseMode) {
      return;
    }
    GithubVersionModel githubVersionModel =
        await ApiClient().getGithubVersion();
    String currentVersion = await getCurrentVersion();
    String githubVersion = githubVersionModel.version ?? 'v0.0.2';
    String githubUpdateInfo = githubVersionModel.body ?? 'Something wrong';
    if (compareVersion(currentVersion, githubVersion)) {
      Widget dialog = SingleChildScrollView(
              child: <Widget>[
        Text('${I18n.latest_version.tr}: $githubVersion'),
        Text('${I18n.current_version.tr}: $currentVersion'),
        MarkdownBody(data: githubUpdateInfo),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start))
          .constrained(height: 300, width: 300);
      Get.defaultDialog(title: I18n.find_new_version.tr, content: dialog);
    }
  }
}
