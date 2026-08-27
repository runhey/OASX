import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:oasx/api/api_client.dart';
import 'package:oasx/config/translation/i18n_content.dart';

class ToolView extends StatelessWidget {
  const ToolView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotifyTest(),
          DiagnosticExport(),
        ],
      ),
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
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium),
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

class DiagnosticExport extends StatefulWidget {
  const DiagnosticExport({Key? key}) : super(key: key);

  @override
  DiagnosticExportState createState() => DiagnosticExportState();
}

class DiagnosticExportState extends State<DiagnosticExport> {
  bool _loading = false;
  String _result = '';

  Future<void> _export() async {
    setState(() {
      _loading = true;
      _result = '';
    });
    final res = await ApiClient().exportDiagnostic();
    final path = (res != null && res['success'] == true)
        ? (res['path']?.toString() ?? '')
        : '';
    if (!mounted) return;
    setState(() {
      _loading = false;
      _result = path.isNotEmpty
          ? '${I18n.export_diagnostic_done.tr}$path'
          : I18n.export_diagnostic_failed.tr;
    });
    if (path.isNotEmpty) {
      try {
        await launchUrl(Uri.file(File(path).parent.path));
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.export_diagnostic.tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Text(I18n.export_diagnostic_help.tr,
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 16),
      MaterialButton(
        color: Theme.of(context).canvasColor,
        onPressed: _loading ? null : _export,
        child: _loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
            : Text(I18n.export_diagnostic_button.tr),
      ).constrained(width: 300),
      if (_result.isNotEmpty) ...[
        const SizedBox(height: 10),
        SelectableText(_result,
            style: Theme.of(context).textTheme.bodySmall),
      ],
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .padding(all: 10)
        .card(margin: const EdgeInsets.all(10))
        .constrained(maxWidth: 300, width: 300);
  }
}
