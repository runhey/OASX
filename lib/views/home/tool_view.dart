import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/api/api_client.dart';
import 'package:oasx/translation/i18n_content.dart';

import '../../translation/i18n_content.dart';

class ToolView extends StatelessWidget {
  const ToolView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: NotifyTest(),
    );
  }
}

class NotifyTest extends StatefulWidget {
  const NotifyTest({Key? key}) : super(key: key);

  @override
  NotifyTestState createState() => NotifyTestState();
}

class NotifyTestState extends State<NotifyTest> {
  String testConfig = 'provider:';
  String testTitle = 'Title';
  String testContent = 'Content';

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.notify_test.tr,
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
      _config(),
      _title(),
      _content(),
      const SizedBox(
        height: 20,
      ),
      _send(),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .padding(all: 10)
        .card(margin: const EdgeInsets.all(10))
        .constrained(maxWidth: 300, width: 300);
  }

  Widget _config() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        initialValue: testConfig,
        decoration: InputDecoration(
            labelText: I18n.notify_test_config.tr,
            helperText: I18n.notify_test_help.tr),
        onChanged: (value) {
          setState(() {
            testConfig = value;
          });
        }).constrained(width: 300);
  }

  Widget _title() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        initialValue: testTitle,
        decoration: InputDecoration(
          labelText: I18n.notify_test_title.tr,
        ),
        onChanged: (value) {
          setState(() {
            testTitle = value;
          });
        }).constrained(width: 300);
  }

  Widget _content() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        initialValue: testContent,
        decoration: InputDecoration(
          labelText: I18n.notify_test_content.tr,
        ),
        onChanged: (value) {
          setState(() {
            testContent = value;
          });
        }).constrained(width: 300);
  }

  Widget _send() {
    return MaterialButton(
      color: Theme.of(context).canvasColor,
      onPressed: () {
        ApiClient().notifyTest(testConfig, testTitle, testContent);
      },
      child: Text(I18n.notify_test_send.tr),
    ).constrained(width: 300);
  }
}
