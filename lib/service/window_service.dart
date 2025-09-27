import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/model/window_state.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:window_manager/window_manager.dart';

class WindowService extends GetxService with WindowListener {
  final _storage = GetStorage();

  Timer? _debounceTimer;
  DateTime? _lastSaveTime;
  final enableWindowState = false.obs;

  Future<WindowService> init() async {
    if (!PlatformUtils.isDesktop) return this;
    await windowManager.ensureInitialized();
    WindowStateModel? lastState;
    if (_storage.read(StorageKey.enableWindowState.name) ?? false) {
      final jsonStr = _storage.read(StorageKey.windowState.name);
      if (jsonStr != null) {
        try {
          lastState = WindowStateModel.fromJson(
              json.decode(jsonStr) as Map<String, dynamic>);
        } catch (e) {
          printError(info: 'window state parsing failed：$jsonStr');
        }
        if (lastState != null) {
          await windowManager.setBounds(Rect.fromLTWH(
            lastState.x,
            lastState.y,
            lastState.width,
            lastState.height,
          ));
        }
      }
    }
    WindowOptions windowOptions = WindowOptions(
      size: (lastState != null)
          ? Size(lastState.width, lastState.height)
          : const Size(1200, 800),
      center: lastState == null,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.addListener(this);
    return this;
  }

  @override
  void onInit() {
    enableWindowState.value =
        _storage.read(StorageKey.enableWindowState.name) ?? false;
    super.onInit();
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
    await _saveWindowState();
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
}
