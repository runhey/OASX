import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart' show MarkdownWidget;

import 'package:oasx/api/api_client.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/api/home_model.dart';
import 'package:oasx/config/github_readme.dart' show githubReadme;

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
}
