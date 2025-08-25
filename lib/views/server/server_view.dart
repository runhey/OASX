library server;

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/component/log/log_mixin.dart';
import 'package:oasx/component/log/log_widget.dart';
import 'package:process_run/shell.dart';
import 'dart:io';
import 'package:styled_widget/styled_widget.dart';
import 'package:code_editor/code_editor.dart';

import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';
import 'package:oasx/controller/settings.dart';
import 'package:oasx/utils/platform_utils.dart';

part './deploy_view.dart';
part '../../controller/server/server_controller.dart';

class ServerView extends StatelessWidget {
  const ServerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbar = switch (PlatformUtils.platfrom()) {
      PlatformType.windows => windowAppbar(),
      PlatformType.linux => desktopAppbar(),
      PlatformType.macOS => desktopAppbar(),
      PlatformType.android => mobileTabletAppbar(),
      PlatformType.iOS => mobileTabletAppbar(),
      PlatformType.web => webAppbar(),
      _ => webAppbar(),
    };
    return Scaffold(
      appBar: appbar,
      floatingActionButton: startServerButton(),
      body: _body(),
    );
  }

  Widget _body() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      ServerController serverController = Get.find<ServerController>();
      return SingleChildScrollView(
          child: Column(
        spacing: 6,
        children: [
          ExpansionTileGroup(
            toggleType: ToggleType.expandOnlyCurrent,
            children: [
              path(),
              deploy(constraints.maxHeight - 200),
            ],
          ),
          LogWidget(key: ValueKey(serverController.hashCode),controller: serverController, title: I18n.setup_log.tr)
              .constrained(height: constraints.maxHeight - 200)
        ],
      ).padding(right: 10, left: 10));
    });
  }

  ExpansionTileItem path() {
    Widget path = GetX<ServerController>(builder: (controller) {
      return <Widget>[
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
    });
    Widget pass = GetX<ServerController>(builder: (controller) {
      return <Widget>[
        controller.rootPathAuthenticated.value
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.error, color: Colors.red),
        Text(
          controller.rootPathAuthenticated.value
              ? I18n.root_path_correct.tr
              : I18n.root_path_incorrect.tr,
          // style: Get.textTheme.titleMedium
        ),
      ].toRow();
    });

    return ExpansionTileItem(
      initiallyExpanded: false,
      isHasTopBorder: false,
      isHasBottomBorder: false,
      collapsedBackgroundColor:
          Get.theme.colorScheme.secondaryContainer.withOpacity(0.24),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      title: pass,
      children: [
        path,
        Text(I18n.root_path_server_help.tr),
      ],
    );
  }

  ExpansionTileItem deploy(double maxHeight) {
    return ExpansionTileItem(
      initiallyExpanded: false,
      isHasTopBorder: false,
      isHasBottomBorder: false,
      collapsedBackgroundColor:
          Get.theme.colorScheme.secondaryContainer.withOpacity(0.24),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      title: Text(I18n.setup_deploy.tr, style: Get.textTheme.titleMedium),
      children: [
        SingleChildScrollView(
          child: code(maxHeight - 50),
        ).constrained(height: maxHeight)
      ],
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

  Widget code(double maxHeight) {
    return GetX<ServerController>(builder: (controller) {
      FileEditor file = FileEditor(
        name: "deploy.yaml",
        language: "yaml",
        code: controller.deployContent.value, // [code] needs a string
      );
      EditorModel model = EditorModel(
        files: [file], // the files created above
        // you can customize the editor as you want
        styleOptions: EditorModelStyleOptions(
          heightOfContainer: maxHeight,
          // theme: githubTheme,
        ),
      );
      return CodeEditor(
        model: model,
        formatters: const ["yaml"],
        onSubmit: (String language, String value) {
          controller.writeDeploy(value);
        },
      );
    });
  }
}
