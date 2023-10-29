library overview;

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/views/nav/view_nav.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    NavCtrl navCtroler = Get.find<NavCtrl>();
    return GetX<OverviewController>(
        tag: navCtroler.selectedScript.value,
        builder: (OverviewController cont) {
          OverviewController controller = Get.find<OverviewController>(
              tag: navCtroler.selectedScript.value);
          Widget stateText = switch (controller.scriptState.value) {
            ScriptState.running => const Text("Running"),
            ScriptState.inactive => const Text("Inactive"),
            ScriptState.warning => const Text("Warning"),
            ScriptState.updating => const Text("Updating"),
          };
          Widget stateSpinKit = switch (controller.scriptState.value) {
            ScriptState.running => const SpinKitChasingDots(
                color: Colors.green,
                size: 22,
              ),
            ScriptState.inactive =>
              const Icon(Icons.donut_large, size: 30, color: Colors.grey),
            ScriptState.warning =>
              const SpinKitDoubleBounce(color: Colors.orange, size: 30),
            ScriptState.updating => const Icon(Icons.browser_updated_rounded,
                size: 30, color: Colors.blue),
          };
          return <Widget>[
            Text("Scheduler",
                textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
            stateSpinKit,
            stateText,
            IconButton(
              onPressed: () => {controller.activeScript()},
              icon: const Icon(Icons.power_settings_new_rounded),
              isSelected: controller.scriptState.value == ScriptState.running,
            ).paddingOnly(right: 0),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .paddingOnly(left: 8, right: 8)
              .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
        });
  }

  Widget _running() {
    NavCtrl navCtroler = Get.find<NavCtrl>();
    return GetX<OverviewController>(
        tag: navCtroler.selectedScript.value,
        builder: (OverviewController controller) {
          OverviewController controller = Get.find<OverviewController>(
              tag: navCtroler.selectedScript.value);
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
    NavCtrl navCtroler = Get.find<NavCtrl>();
    return GetX<OverviewController>(
        tag: navCtroler.selectedScript.value,
        builder: (OverviewController controller) {
          OverviewController controller = Get.find<OverviewController>(
              tag: navCtroler.selectedScript.value);
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
    NavCtrl navCtroler = Get.find<NavCtrl>();
    return GetX<OverviewController>(
        tag: navCtroler.selectedScript.value,
        builder: (OverviewController controller) {
          OverviewController controller = Get.find<OverviewController>(
              tag: navCtroler.selectedScript.value);
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
    NavCtrl navCtroler = Get.find<NavCtrl>();
    return GetX<OverviewController>(
        tag: navCtroler.selectedScript.value,
        builder: (OverviewController controller) {
          OverviewController controller = Get.find<OverviewController>(
              tag: navCtroler.selectedScript.value);
          return EasyRichText(
            controller.log.value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            selectable: true,
            defaultStyle: Get.textTheme.titleSmall,
            patternList: [
              // INFO
              EasyRichTextPattern(
                targetString: 'INFO',
                style:
                    const TextStyle(color: Color.fromARGB(255, 55, 109, 136)),
              ),
              // WARNING
              EasyRichTextPattern(
                targetString: 'WARNING',
                style: const TextStyle(color: Colors.yellow),
              ),
              // ERROR
              EasyRichTextPattern(
                targetString: 'ERROR',
                style: const TextStyle(color: Colors.red),
              ),
              // CRITICAL
              EasyRichTextPattern(
                targetString: 'CRITICAL',
                style: const TextStyle(color: Colors.red),
              ),
              // 时间的
              EasyRichTextPattern(
                targetString: r'(\d{2}:\d{2}:\d{2}\.\d{3})',
                style: const TextStyle(color: Colors.cyan),
              ),
              // 粗体
              EasyRichTextPattern(
                targetString: r'[\{\[\(\)\]\}]',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // True
              EasyRichTextPattern(
                  targetString: 'True',
                  style: const TextStyle(color: Colors.lightGreen)),
              // False
              EasyRichTextPattern(
                  targetString: 'False',
                  style: const TextStyle(color: Colors.red)),
              // None
              EasyRichTextPattern(
                  targetString: 'None',
                  style: const TextStyle(color: Colors.purple)),
              // 路径Path
              // EasyRichTextPattern(
              //     targetString: r'([A-Za-z]\:)|.)?\B([\/\\][\w\.\-\_\+]+)*[\/\\]',
              //     style: const TextStyle(
              //         color: Colors.purple, fontStyle: FontStyle.italic)),
              // 分割线
              EasyRichTextPattern(
                targetString: r'(══*══)|(──*──)',
                style: const TextStyle(color: Colors.lightGreen),
              )
            ],
          )
              .paddingAll(10)
              .constrained(width: double.infinity, height: double.infinity)
              .card(margin: const EdgeInsets.fromLTRB(0, 0, 10, 10));
        });
  }
}
