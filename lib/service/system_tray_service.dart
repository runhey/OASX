import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:oasx/views/overview/overview_view.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class SystemTrayService extends GetxService {
  final SystemTray _systemTray = SystemTray();
  final AppWindow _appWindow = AppWindow();

  bool _isTrayVisible = false;

  Future<void> showTray() async {
    if (_isTrayVisible || !PlatformUtils.isDesktop) return;
    String iconPath = Platform.isWindows
        ? 'assets/images/Icon-app.ico'
        : 'assets/images/Icon-app.png';
    await _systemTray.initSystemTray(
      title: "OASX",
      iconPath: iconPath,
    );
    await _rebuildMenu();
    _systemTray.registerSystemTrayEventHandler((eventName) async {
      if (eventName == kSystemTrayEventClick) {
        // 单击默认显示窗口
        await windowManager.setPreventClose(true);
        await windowManager.show();
        await windowManager.focus();
        await hideTray();
      } else if (eventName == kSystemTrayEventRightClick) {
        // 右键打开菜单
        Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
      }
    });
    _isTrayVisible = true;
  }

  Future<void> hideTray() async {
    if (_isTrayVisible) {
      await _systemTray.destroy();
      _isTrayVisible = false;
    }
  }

  Future<void> _rebuildMenu() async {
    final scriptService = Get.find<ScriptService>();
    final Menu mainMenu = Menu();
    await mainMenu.buildFrom([
      SubMenu(
          label: I18n.script_list.tr,
          children: scriptService.scriptModelMap.values
              .map((e) => MenuItemCheckbox(
                    label: buildCheckBoxLabel(e),
                    checked: e.state.value == ScriptState.running,
                    onClicked: (menuItem) async {
                      if (menuItem.checked) { // 当前正在运行
                        await Get.find<ScriptService>().stopScript(e.name);
                      } else {
                        await Get.find<ScriptService>().startScript(e.name);
                      }
                      await menuItem.setCheck(!menuItem.checked);
                    },
                  ))
              .toList()),
      MenuSeparator(),
      MenuItemLabel(
        label: I18n.showWindow.tr,
        onClicked: (_) async {
          await windowManager.setPreventClose(true);
          await windowManager.show();
          await windowManager.focus();
          await hideTray();
        },
      ),
      MenuItemLabel(
        label: I18n.exit.tr,
        onClicked: (_) async {
          await windowManager.setPreventClose(false);
          await hideTray();
          await windowManager.close();
        },
      ),
    ]);
    await _systemTray.setContextMenu(mainMenu);
  }

  String buildCheckBoxLabel(ScriptModel scriptModel) {
    if (scriptModel.runningTask.value.isAllEmpty()) {
      return scriptModel.name;
    }
    return '${scriptModel.name} - ${scriptModel.runningTask.value.taskName.tr}';
  }
}
