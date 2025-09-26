library overview;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/component/log/log_mixin.dart';
import 'package:oasx/component/log/log_widget.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/service/websocket_service.dart';
import 'package:oasx/utils/extension_utils.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/translation/i18n_content.dart';


part '../../controller/overview/overview_controller.dart';
part '../../controller/overview/taskitem_model.dart';
part './taskitem_view.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavCtrl navController = Get.find<NavCtrl>();
    OverviewController overviewController =
        Get.find<OverviewController>(tag: navController.selectedScript.value);
    if (context.mediaQuery.orientation == Orientation.portrait) {
      // 竖方向
      return SingleChildScrollView(
        child: <Widget>[
          _scheduler(context, overviewController),
          _running(context, overviewController),
          _pendings(context, overviewController),
          _waitings(context, overviewController).constrained(maxHeight: 200),
          LogWidget(
                  key: ValueKey(overviewController.hashCode),
                  controller: overviewController,
                  title: I18n.log.tr,
                  enableCollapse: false)
              .constrained(maxHeight: 500)
              .marginOnly(left: 10, top: 10, right: 10)
        ].toColumn(),
      );
    } else {
      //横方向
      return <Widget>[
        // 左边
        <Widget>[
          _scheduler(context, overviewController),
          _running(context, overviewController),
          _pendings(context, overviewController),
          Expanded(child: _waitings(context, overviewController)),
        ].toColumn().constrained(width: 300),
        // 右边
        LogWidget(
                key: ValueKey(overviewController.hashCode),
                controller: overviewController,
                title: I18n.log.tr,
                enableCollapse: false)
            .marginOnly(right: 10)
            .expanded()
      ].toRow();
    }
  }

  Widget _scheduler(BuildContext context, OverviewController controller) {
    return <Widget>[
      Text(I18n.scheduler.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      <Widget>[
        Obx(() {
          return switch (controller.scriptModel.state.value) {
            ScriptState.running => const SpinKitChasingDots(
                color: Colors.green,
                size: 22,
              ),
            ScriptState.inactive =>
              const Icon(Icons.donut_large, size: 26, color: Colors.grey),
            ScriptState.warning =>
              const SpinKitDoubleBounce(color: Colors.orange, size: 26),
            ScriptState.updating => const Icon(Icons.browser_updated_rounded,
                size: 26, color: Colors.blue),
          };
        }),
        Obx(() {
          return IconButton(
            onPressed: () => {controller.toggleScript()},
            icon: const Icon(Icons.power_settings_new_rounded),
            isSelected:
                controller.scriptModel.state.value == ScriptState.running,
          );
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center)
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .constrained(height: 48)
        .paddingOnly(left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }

  Widget _running(BuildContext context, OverviewController controller) {
    return <Widget>[
      Text(I18n.running.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      Obx(() {
        return TaskItemView(controller.scriptModel.runningTask.value);
      })
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .padding(top: 8, bottom: 0, left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }

  Widget _pendings(BuildContext context, OverviewController controller) {
    return <Widget>[
      Text(I18n.pending.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      SizedBox(
          height: 140,
          child: Obx(() {
            return ListView.builder(
                itemBuilder: (context, index) =>
                    TaskItemView(controller.scriptModel.pendingTaskList[index]),
                itemCount: controller.scriptModel.pendingTaskList.length);
          }))
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .padding(top: 8, bottom: 0, left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }

  Widget _waitings(BuildContext context, OverviewController controller) {
    return <Widget>[
      Text(I18n.waiting.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      Expanded(child: Obx(() {
        return ListView.builder(
            itemBuilder: (context, index) =>
                TaskItemView(controller.scriptModel.waitingTaskList[index]),
            itemCount: controller.scriptModel.waitingTaskList.length);
      }))
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .paddingAll(8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }
}
