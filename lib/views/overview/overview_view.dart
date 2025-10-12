library overview;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/component/blur_loading_overlay.dart';
import 'package:oasx/component/log/log_mixin.dart';
import 'package:oasx/component/log/log_widget.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/service/theme_service.dart';
import 'package:oasx/utils/time_utils.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          _SchedulerWidget(controller: overviewController),
          _RunningWidget(controller: overviewController),
          _PendingWidget(controller: overviewController),
          _WaitingWidget(controller: overviewController)
              .constrained(maxHeight: 200),
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
          _SchedulerWidget(controller: overviewController),
          _RunningWidget(controller: overviewController),
          _PendingWidget(controller: overviewController),
          Expanded(child: _WaitingWidget(controller: overviewController)),
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
}

class _WaitingWidget extends StatelessWidget {
  const _WaitingWidget({
    required this.controller,
  });

  final OverviewController controller;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.waiting.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      Expanded(
        child: DragTarget<Map<String, dynamic>>(
          onWillAcceptWithDetails: (details) {
            if (details.data.isEmpty ||
                details.data.length != 2 ||
                details.data['source'] == null ||
                details.data['model'] == null) {
              return false;
            }
            final source = details.data['source'] as String;
            return source != 'waiting';
          },
          onAcceptWithDetails: (details) async {
            final model = details.data['model'] as TaskItemModel;
            await controller.onMoveToWaiting(model);
          },
          builder: (context, candidateData, rejectedData) {
            return Obx(() {
              return BlurLoadingOverlay(
                loading: controller.isWaitingLoading.value,
                child: ListView.builder(
                  itemBuilder: (context, index) => TaskItemView(
                    controller.scriptModel.waitingTaskList[index],
                    source: 'waiting',
                  ),
                  itemCount: controller.scriptModel.waitingTaskList.length,
                ).decorated(
                    border: Border.all(
                      color: candidateData.isNotEmpty
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8)),
              );
            });
          },
        ),
      ),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .paddingAll(8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }
}

class _PendingWidget extends StatelessWidget {
  const _PendingWidget({
    required this.controller,
  });

  final OverviewController controller;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.pending.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      DragTarget<Map<String, dynamic>>(
        onWillAcceptWithDetails: (details) {
          if (details.data.isEmpty ||
              details.data.length != 2 ||
              details.data['source'] == null ||
              details.data['model'] == null) {
            return false;
          }
          final source = details.data['source'] as String;
          return source != 'pending';
        },
        onAcceptWithDetails: (details) async {
          final model = details.data['model'] as TaskItemModel;
          await controller.onMoveToPending(model);
        },
        builder: (context, candidateData, rejectedData) {
          return Obx(() {
            return BlurLoadingOverlay(
              loading: controller.isPendingLoading.value,
              child: ListView.builder(
                itemBuilder: (context, index) => TaskItemView(
                  controller.scriptModel.pendingTaskList[index],
                  source: 'pending',
                ),
                itemCount: controller.scriptModel.pendingTaskList.length,
              ).height(140).decorated(
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? Colors.green
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8)),
            );
          });
        },
      ),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }
}

class _RunningWidget extends StatelessWidget {
  const _RunningWidget({
    required this.controller,
  });

  final OverviewController controller;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.running.tr,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      Obx(() {
        final state = controller.scriptModel.state.value;
        final task = controller.scriptModel.runningTask.value;
        // 非 running 状态允许拖拽
        final enableDrag = state != ScriptState.running;
        return TaskItemView(
          task,
          source: 'running',
          enableDrag: enableDrag,
        );
      })
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .padding(top: 8, bottom: 0, left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }
}

class _SchedulerWidget extends StatelessWidget {
  const _SchedulerWidget({
    required this.controller,
  });

  final OverviewController controller;

  @override
  Widget build(BuildContext context) {
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
}
