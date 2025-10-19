library overview;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/component/blur_loading_overlay.dart';
import 'package:oasx/component/log/log_mixin.dart';
import 'package:oasx/component/log/log_widget.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/service/theme_service.dart';
import 'package:oasx/utils/time_utils.dart';
import 'package:oasx/views/args/args_view.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/translation/i18n_content.dart';

part '../../controller/overview/overview_controller.dart';
part '../../controller/overview/taskitem_model.dart';
part './taskitem_view.dart';
part './widgets/pending_task_widget.dart';
part './widgets/waiting_task_widget.dart';
part './widgets/running_task_widget.dart';
part './widgets/task_scheduler_widget.dart';

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
