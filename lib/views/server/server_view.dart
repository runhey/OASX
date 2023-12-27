library server;

import 'dart:math';

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:process_run/shell.dart';
import 'dart:io';
import 'package:styled_widget/styled_widget.dart';
import 'package:code_editor/code_editor.dart';

import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';
import 'package:oasx/controller/settings.dart';

part './deploy_view.dart';
part '../../controller/server/server_controller.dart';

class ServerView extends StatelessWidget {
  const ServerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbar = switch (Theme.of(context).platform) {
      TargetPlatform.windows => windowAppbar(),
      TargetPlatform.linux => desktopAppbar(),
      TargetPlatform.macOS => desktopAppbar(),
      TargetPlatform.android => mobileTabletAppbar(),
      TargetPlatform.iOS => mobileTabletAppbar(),
      _ => desktopAppbar(),
    };
    return Scaffold(
      appBar: appbar,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: startServerButton(),
      body: _body(),
    );
  }

  Widget _body() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: [
          rootPath(),
          deploy(constraints.maxHeight - 250),
          log(constraints.maxHeight - 250)
        ].toColumn(),
      );
    });
  }

  Widget rootPath() {
    return GetX<ServerController>(
      builder: (controller) {
        Widget path = <Widget>[
          Text(I18n.root_path_server.tr, style: Get.textTheme.titleMedium),
          const SizedBox(
            width: 10,
          ),
          Text(controller.rootPathServer.value),
          TextButton(
              onPressed: () async {
                String? selectedDirectory =
                    await FilePicker.platform.getDirectoryPath();
                if (selectedDirectory == null) {
                  // User canceled the picker
                  return;
                }
                controller.updateRootPathServer(selectedDirectory);
              },
              child: Text(I18n.select_root_path_server.tr))
        ].toRow();
        Widget pass = <Widget>[
          controller.rootPathAuthenticated.value
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.error, color: Colors.red),
          Text(controller.rootPathAuthenticated.value
              ? I18n.root_path_correct.tr
              : I18n.root_path_incorrect.tr),
        ].toRow();
        return <Widget>[path, Text(I18n.root_path_server_help.tr), pass]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .paddingAll(10)
            .card(margin: const EdgeInsets.all(10));
      },
    );
  }

  Widget deploy(double maxHeight) {
    return GetX<ServerController>(
      builder: (controller) {
        return ExpansionTileItem(
          initiallyExpanded: controller.showDeploy.value,
          isHasTopBorder: false,
          isHasBottomBorder: false,
          backgroundColor:
              Get.theme.colorScheme.secondaryContainer.withOpacity(0.24),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          title: const Text('Deploy'),
          children: [
            SingleChildScrollView(
              child: SelectableText(controller.log.value),
            ).constrained(height: maxHeight)
          ],
        ).padding(right: 10, left: 10);
      },
    );
  }

  Widget botton() {
    return GetX<ServerController>(
      builder: (controller) {
        return TextButton(onPressed: () {}, child: Text('dddd'));
      },
    );
  }

  Widget log(double maxHeight) {
    return GetX<ServerController>(
      builder: (controller) {
        return ExpansionTileItem(
            initiallyExpanded: true,
            isHasTopBorder: false,
            isHasBottomBorder: false,
            collapsedBackgroundColor:
                Get.theme.colorScheme.secondaryContainer.withOpacity(0.24),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            title: Text('Log'),
            children: [
              SingleChildScrollView(
                child: SelectableText(controller.log.value),
              ).constrained(height: maxHeight),
            ]).padding(right: 10, left: 10);
        // [

        // ]
        //     .toRow(crossAxisAlignment: CrossAxisAlignment.start)
        //
        //     .constrained(height: 400)
        //     .card(margin: const EdgeInsets.all(10), semanticContainer: false);
      },
    );
  }

  Widget startServerButton() {
    return GetX<ServerController>(builder: (controller) {
      if (controller.rootPathAuthenticated.value) {
        return FloatingActionButton(
            child: const Icon(Icons.auto_mode_rounded),
            onPressed: () {
              controller.run();
            });
      } else {
        return const SizedBox(
          width: 100,
          height: 100,
        );
      }
    });
  }
}
