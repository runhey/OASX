library server;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'dart:io';
import 'package:oasx/controller/settings.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';

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
    return SingleChildScrollView(
      child: [rootPath()].toColumn(),
    );
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

  Widget deploy() {
    return GetX<ServerController>(
      builder: (controller) {
        return Text('deploy');
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

  Widget log() {
    return GetX<ServerController>(
      builder: (controller) {
        return Text(controller.log.value);
      },
    );
  }

  Widget startServerButton() {
    return GetX<ServerController>(builder: (controller) {
      if (controller.rootPathAuthenticated.value) {
        return FloatingActionButton(
            child: const Icon(Icons.auto_mode_rounded), onPressed: () {});
      } else {
        return const SizedBox(
          width: 100,
          height: 100,
        );
      }
    });
  }
}
