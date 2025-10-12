import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/model/window_state.dart';
import 'package:oasx/service/system_tray_service.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:window_manager/window_manager.dart';

class WindowService extends GetxService with WindowListener {
  final _storage = GetStorage();

  Timer? _debounceTimer;
  DateTime? _lastSaveTime;
  final enableWindowState = false.obs;
  final enableSystemTray = false.obs;

  @override
  Future<void> onInit() async {
    if (PlatformUtils.isDesktop) {
      await windowManager.ensureInitialized();
      enableWindowState.value =
          _storage.read(StorageKey.enableWindowState.name) ?? false;
      enableSystemTray.value =
          _storage.read(StorageKey.enableSystemTray.name) ?? false;
      WindowStateModel? lastState = await initWindowState();
      await initSystemTray();
      windowManager.waitUntilReadyToShow(buildWindowOptions(lastState),
          () async {
        await windowManager.show();
        await windowManager.focus();
      });
      windowManager.addListener(this);
    }
    super.onInit();
  }

  Future<void> initSystemTray() async {
    if (enableSystemTray.value) {
      // 取消系统关闭事件
      await windowManager.setPreventClose(true);
      await Get.find<SystemTrayService>().showTray();
    }
  }

  WindowOptions buildWindowOptions(WindowStateModel? lastState) {
    return WindowOptions(
      size: (lastState != null)
          ? Size(lastState.width, lastState.height)
          : const Size(1200, 800),
      center: lastState == null,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
  }

  Future<WindowStateModel?> initWindowState() async {
    if (!enableWindowState.value) return null;
    final jsonStr = _storage.read(StorageKey.windowState.name);
    if (jsonStr == null) return null;
    WindowStateModel? lastState =
        WindowStateModel.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
    await windowManager.setBounds(Rect.fromLTWH(
      lastState.x,
      lastState.y,
      lastState.width,
      lastState.height,
    ));
    return lastState;
  }

  Future<void> _saveWindowState() async {
    if (!PlatformUtils.isDesktop || !enableWindowState.value) return;
    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();
    final state = WindowStateModel(
      x: pos.dx,
      y: pos.dy,
      width: size.width,
      height: size.height,
    );
    _storage.write(StorageKey.windowState.name, json.encode(state.toJson()));
    printInfo(info: 'save window state:${state.toJson()}');
  }

  void _scheduleSave() {
    if (!PlatformUtils.isDesktop || !enableWindowState.value) return;
    final now = DateTime.now();
    if (_lastSaveTime == null ||
        now.difference(_lastSaveTime!) > const Duration(seconds: 2)) {
      _lastSaveTime = now;
      _saveWindowState();
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      _lastSaveTime = DateTime.now();
      await _saveWindowState();
    });
  }

  @override
  void onWindowMove() => _scheduleSave();
  @override
  void onWindowResize() => _scheduleSave();

  @override
  void onWindowClose() async {
    _debounceTimer?.cancel();
    final preventClose = await windowManager.isPreventClose();
    if (!preventClose) return;
    await _saveWindowState();
    // 检查是否已经设置了最小化到托盘的选项
    if (enableSystemTray.value) {
      await windowManager.hide();
      return;
    }
    await windowManager.setPreventClose(false);
    await windowManager.close();
  }

  @override
  void onClose() {
    if (PlatformUtils.isDesktop) {
      windowManager.removeListener(this);
    }
    _debounceTimer?.cancel();
    super.onClose();
  }

  void updateWindowStateEnable(bool newVal) {
    enableWindowState.value = newVal;
    _storage.write(StorageKey.enableWindowState.name, newVal);
  }

  void updateSystemTrayEnable(bool newVal) {
    enableSystemTray.value = newVal;
    _storage.write(StorageKey.enableSystemTray.name, newVal);
    // 开启托盘就阻止系统关闭事件,关闭托盘则允许系统关闭事件
    windowManager.setPreventClose(newVal);
  }
}
