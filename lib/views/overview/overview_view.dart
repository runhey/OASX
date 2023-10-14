library overview;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

part '../../controller/overview/overview_controller.dart';
part '../../controller/overview/taskitem_model.dart';
part './taskitem_view.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const Text("xxx");
    if (context.mediaQuery.orientation == Orientation.portrait) {
      // 竖方向
      return <Widget>[
        _scheduler(),
        _running(),
        _pendings(),
        _waitings().constrained(maxHeight: 200),
        _logTitle(),
        _log()
      ].toColumn();
    } else {
      //横方向
      return <Widget>[
        // 左边
        <Widget>[
          _scheduler(),
          _running(),
          _pendings(),
          Expanded(child: _waitings()),
        ].toColumn().constrained(width: 300),
        // 右边
        <Widget>[_logTitle(), _log().expanded()]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .expanded()
      ].toRow();
    }
  }

  Widget _scheduler() {
    return <Widget>[
      Text("Scheduler",
          textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
      IconButton(
        onPressed: () => {},
        icon: const Icon(Icons.power_settings_new_rounded),
        isSelected: false,
      ).paddingOnly(right: 10),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingOnly(left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }

  Widget _running() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      return <Widget>[
        Text("Running",
            textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
        const Divider(),
        TaskItemView.fromModel(controller.running.value)
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(8)
          .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
    });
  }

  Widget _pendings() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      OverviewController controller = Get.find();
      return <Widget>[
        Text("Pandings",
            textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
        const Divider(),
        SizedBox(
            height: 160,
            child: ListView.builder(
                itemBuilder: (context, index) =>
                    TaskItemView.fromModel(controller.pendings[index]),
                itemCount: controller.pendings.length))
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(8)
          .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
    });
  }

  Widget _waitings() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      return <Widget>[
        Text("Waitings",
            textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
        const Divider(),
        Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) =>
                    TaskItemView.fromModel(controller.waitings[index]),
                itemCount: controller.waitings.length))
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .paddingAll(8)
          .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
    });
  }

  Widget _logTitle() {
    return <Widget>[
      Text("Log", textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
      // MaterialButton(
      //   onPressed: () => {},
      //   child: const Text("Auto Scroll ON"),
      // ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingAll(8)
        .card(margin: const EdgeInsets.fromLTRB(0, 0, 10, 10));
  }

  Widget _log() {
    return const Text("ddddd")
        .constrained(width: double.infinity, height: double.infinity)
        .card(margin: const EdgeInsets.fromLTRB(0, 0, 10, 10));
  }
}
