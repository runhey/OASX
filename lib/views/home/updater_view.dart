import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/api/update_info_model.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/config/global.dart';

class UpdaterView extends StatelessWidget {
  const UpdaterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpdateInfoModel>(
        future: ApiClient().getUpdateInfo(),
        builder:
            (BuildContext context, AsyncSnapshot<UpdateInfoModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 当Future还未完成时，显示加载中的UI
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // 当Future发生错误时，显示错误提示的UI
            return Text('Error: ${snapshot.error}');
          } else {
            // 当Future成功完成时，显示数据
            UpdateInfoModel data = snapshot.data!;
            return SingleChildScrollView(
              child: content(data).paddingAll(20),
            );
          }
        });
  }

  Widget content(UpdateInfoModel data) {
    // String currentVersion = Get.find<SettingsController>().version.value;
    Widget version = Text('${I18n.current_version.tr}: ${GlobalVar.version}',
        style: Get.textTheme.titleMedium);
    Widget title = <Widget>[
      data.isUpdate!
          ? const Icon(Icons.cloud_download)
          : const Icon(
              Icons.cloud_off,
              color: Colors.green,
            ),
      data.isUpdate!
          ? Text(I18n.find_oas_new_version.tr, style: Get.textTheme.titleMedium)
          : Text(I18n.oas_latest_version.tr, style: Get.textTheme.titleMedium),
      const SizedBox(
        width: 20,
      ),
      Text('${I18n.current_branch.tr}: ${data.branch}',
              style: Get.textTheme.titleMedium, textAlign: TextAlign.center)
          .constrained(height: 26),
      TextButton(
          onPressed: () {
            ApiClient().getExecuteUpdate();
          },
          child: Text(
            I18n.execute_update.tr,
          )),
    ].toRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        separator: const SizedBox(width: 10));
    Table differTable = Table(
      border: tableBorder,
      textBaseline: TextBaseline.alphabetic,
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        differHead,
        genTableRow(data.currentCommit!, differ: true, localRepo: true),
        genTableRow(data.latestCommit!, differ: true)
      ],
    );
    Table submitHistory = Table(
      border: tableBorder,
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: submitHistoryData(data),
    );
    return <Widget>[
      version,
      title,
      differTable,
      Text(I18n.detailed_submission_history.tr,
          style: Get.textTheme.titleMedium),
      submitHistory
    ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separator: const SizedBox(
          height: 10,
        ));
  }

  String sha1(String data) {
    return data.substring(0, 7);
  }

  TableRow genTableRow(List<String> data,
      {bool differ = false, bool localRepo = false}) {
    return TableRow(children: [
      Text(sha1(data[0])).paddingAll(10),
      Text(data[1]).paddingAll(10),
      Text(data[2]).paddingAll(10),
      Text(data[3]).paddingAll(10),
      if (differ)
        localRepo
            ? Text(I18n.local_repo.tr).paddingAll(10)
            : Text(I18n.remote_repo.tr).paddingAll(10)
    ]);
  }

  TableBorder get tableBorder =>
      TableBorder.all(color: Colors.grey, width: 1, style: BorderStyle.solid);

  Map<int, TableColumnWidth> get columnWidths => const {
        0: FixedColumnWidth(80.0),
        1: FixedColumnWidth(140.0),
        2: FixedColumnWidth(200.0),
        // 3: FixedColumnWidth(80.0),
      };

  TableRow get differHead => TableRow(children: [
        Text('SHA1', style: Get.textTheme.titleMedium).paddingAll(10),
        Text(I18n.author.tr, style: Get.textTheme.titleMedium).paddingAll(10),
        Text(I18n.submit_time.tr, style: Get.textTheme.titleMedium)
            .paddingAll(10),
        Text(I18n.submit_info.tr, style: Get.textTheme.titleMedium)
            .paddingAll(10),
        Text('Repo', style: Get.textTheme.titleMedium).paddingAll(10),
      ]);

  TableRow get historyHead => TableRow(children: [
        Text('SHA1', style: Get.textTheme.titleMedium).paddingAll(10),
        Text(I18n.author.tr, style: Get.textTheme.titleMedium).paddingAll(10),
        Text(I18n.submit_time.tr, style: Get.textTheme.titleMedium)
            .paddingAll(10),
        Text(I18n.submit_info.tr, style: Get.textTheme.titleMedium)
            .paddingAll(10),
      ]);

  List<TableRow> submitHistoryData(data) {
    List<TableRow> result =
        data.commit!.map((e) => genTableRow(e)).toList().cast<TableRow>();
    result.insert(0, historyHead);
    return result;
  }
}
