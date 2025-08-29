library nav;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:oasx/views/args/args_view.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:treemenu2/treemenu2.dart';

import 'package:oasx/views/overview/overview_view.dart';
import 'package:oasx/api/api_client.dart';

import '../../comom/i18n_content.dart';
import '../../utils/platform_utils.dart';

part '../../controller/ctrl_nav.dart';
part './tree_menu_view.dart';

class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // 保证至少占满屏幕高度，但如果内容更高就让它自适应
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: _navigationRail(context),
            ),
          ),
        );
      },
    );
  }

  Widget _navigationRail(BuildContext context) {
    return GetX<NavCtrl>(builder: (controller) {
      return NavigationRail(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (value) => {controller.switchScript(value)},
        labelType: NavigationRailLabelType.all, // 就是是否显示文字
        // elevation: 20, // 影深度
        useIndicator: true, // 指示器
        trailing: _trailing(),
        minWidth: 48,
        destinations: _destinations(context, controller.scriptName),
      );
    });
  }

  List<NavigationRailDestination> _destinations(
      BuildContext context, List<String> names) {
    if (names.length <= 1) {
      return [
        NavigationRailDestination(
            icon: const Icon(Icons.home_rounded),
            label: Text(
              'Home'.tr,
            )),
        NavigationRailDestination(
            icon: const Icon(Icons.home_rounded), label: Text('oas1'.tr))
      ];
    }
    return names.map((element) {
      if (element == 'Home') {
        return NavigationRailDestination(
            icon: const Icon(Icons.home_rounded),
            label: Text(
              element.tr,
              style: Get.textTheme.labelMedium,
            ));
      }
      return NavigationRailDestination(
          icon: GestureDetector(
              child: const Icon(Icons.play_circle),
              onSecondaryTapDown: (details) {
                if (PlatformUtils.isMobile) return;
                _showContextMenu(context, details.globalPosition, element);
              },
              onLongPressStart: (details) {
                if (!PlatformUtils.isMobile) return;
                _showContextMenu(context, details.globalPosition, element);
              }),
          label: GestureDetector(
              child: Text(
                element.tr,
                style: Get.textTheme.labelMedium,
              ),
              onSecondaryTapDown: (details) {
                if (PlatformUtils.isMobile) return;
                _showContextMenu(context, details.globalPosition, element);
              },
              onLongPressStart: (details) {
                if (!PlatformUtils.isMobile) return;
                _showContextMenu(context, details.globalPosition, element);
              }));
    }).toList();
  }

  Widget _trailing() {
    return <Widget>[
      IconButton(icon: const Icon(Icons.add), onPressed: addButton),
      // _DarkMode(onPressed: controllerSetting.updateTheme),
      IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Get.toNamed('/settings');
          }),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.end)
        .padding(bottom: 10)
        .expanded();
  }

  Future<void> addButton() async {
    String newName = await ApiClient().getNewConfigName();
    final template = 'template'.obs;
    List<String> configAll = await ApiClient().getConfigAll();
    NavCtrl controllerNav = Get.find<NavCtrl>();
    Get.defaultDialog(
        title: I18n.config_add.tr,
        middleText: '',
        onConfirm: () async {
          Get.back();
          controllerNav.scriptName.value =
          await ApiClient().configCopy(newName, template.value);
        },
        content: <Widget>[
          Text(I18n.new_name.tr),
          TextFormField(
              initialValue: newName,
              onChanged: (value) {
                newName = value;
              }).constrained(width: 200),
          Text(I18n.config_copy_from_exist.tr),
          Obx((){
            return DropdownButton<String>(
              value: template.value,
              menuMaxHeight: 300,
              items: configAll
                  .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                  value: e.toString(),
                  child: Text(
                    e.toString(),
                    style: Get.textTheme.bodyLarge,
                  ).constrained(width: 177)))
                  .toList(),
              onChanged: (value) {
                template.value = value.toString();
              },
            );
          }),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start));
  }

  // 弹出右键/长按菜单
  void _showContextMenu(BuildContext context, Offset position, String name) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx + 5, position.dy + 5),
      items: [
        PopupMenuItem(
          child: <Widget>[
            const Icon(Icons.edit, size: 18),
            const SizedBox(width: 3),
            Text(I18n.rename.tr),
          ]
              .toRow(mainAxisSize: MainAxisSize.min)
              .paddingAll(0)
              .constrained(minWidth: 20, maxWidth: 80, minHeight: 10, maxHeight: 30),
          onTap: () => _showRenameDialog(name),
        ),
        PopupMenuItem(
          child: <Widget>[
            const Icon(Icons.delete, size: 18, color: Colors.red),
            const SizedBox(width: 3),
            Text(I18n.delete.tr),
          ]
              .toRow(mainAxisSize: MainAxisSize.min)
              .paddingAll(0)
              .constrained(minWidth: 20, maxWidth: 80, minHeight: 10, maxHeight: 30),
          onTap: () => _showDeleteDialog(name),
        ),
      ],
    );
  }

  Future<void> _showRenameDialog(String oldName) async {
    final navController = Get.find<NavCtrl>();
    final canRename = await tryCloseScriptWithReason(oldName, 'rename script[$oldName] config file');
    if(!canRename) return;

    String newName = oldName;
    final formKey = GlobalKey<FormState>();
    Get.defaultDialog(
      title: I18n.rename.tr,
      textConfirm: I18n.confirm.tr,
      textCancel: I18n.cancel.tr,
      content: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: I18n.new_name.tr,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return I18n.name_cannot_empty.tr;
              }
              if (['Home', 'home'].contains(value)) {
                return I18n.name_invalid.tr;
              }
              if (oldName == value || navController.scriptName.contains(value)) {
                return I18n.name_duplicate.tr;
              }
              return null;
            },
            onChanged: (v) => newName = v,
          )),
      onConfirm: () async {
        if (!(formKey.currentState?.validate() ?? false)) {
          return;
        }
        Get.back();
        await navController.renameConfig(oldName, newName);
      },
      onCancel: () {},
    );
  }

  Future<void> _showDeleteDialog(String name) async {
    final navController = Get.find<NavCtrl>();
    final canDelete = await tryCloseScriptWithReason(name, 'delete script[$name] config file');
    if (!canDelete) return;
    Get.defaultDialog(
      title: I18n.delete.tr,
      textConfirm: I18n.confirm.tr,
      textCancel: I18n.cancel.tr,
      middleText: '${I18n.delete_confirm.tr} "$name"?',
      onConfirm: () async {
        Get.back();
        await navController.deleteConfig(name);
      },
      onCancel: () {},
    );
  }

  Future<bool> tryCloseScriptWithReason(String scriptName, String reason) async {
    try {
      final overviewController =
          Get.find<OverviewController>(tag: scriptName);
      if (overviewController.scriptState.value != ScriptState.inactive) {
        Get.snackbar(I18n.tip.tr, I18n.config_update_tip.tr,
            duration: const Duration(milliseconds: 2000));
        return false;
      }
      await overviewController.wsClose(WebSocketStatus.normalClosure, reason);
    } catch (e) {
      // overviewController not found is safe to operate
      if (e.toString().contains('not found')) {
        return true;
      }
      // other exceptions are not safe
      return false;
    }
    // not run and close ws success
    return true;
  }
}
