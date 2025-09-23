import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oasx/translation/i18n_content.dart';

mixin LogMixin on GetxController {
  /// max lines to store in log
  int get maxLines => 200;

  /// max logs+pending
  int get maxBuffer => 1000;

  /// max burst line when refreshing
  int get maxBurst => 50;

  /// min burst line when refreshing
  int get minBurst => 1;

  /// ui log
  final logs = <String>[].obs;

  /// auto scroll to bottom
  final autoScroll = true.obs;

  /// collapse log content
  final collapseLog = false.obs;

  /// logs buffer, used to limit speeded log refresh
  final _pendingLogs = <String>[];

  /// refresh timer for log
  Timer? _refreshTimer;

  double _savedScrollOffset = 0.0;

  void Function({bool isJump, bool force, int scrollOffset})? scrollLogs;

  @override
  void onInit() {
    _refreshTimer ??=
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_pendingLogs.isEmpty) {
        return;
      }
      _clearOverflowLogs();
      _updateUILogs();
      _removeUIOldLogs();
      scrollLogs?.call();
    });
    super.onInit();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    super.onClose();
  }

  void _removeUIOldLogs() {
    // UI 限制：只保留最新 maxLines 行
    if (logs.length > maxLines) {
      logs.removeRange(0, logs.length - maxLines);
    }
  }

  void _updateUILogs() {
    // 根据 backlog 动态调整本次要处理多少条
    int backlog = _pendingLogs.length;
    int burst = backlog.clamp(minBurst, maxBurst);
    for (int i = 0; i < burst && _pendingLogs.isNotEmpty; i++) {
      logs.add(_pendingLogs.removeAt(0));
    }
  }

  void _clearOverflowLogs() {
    // 计算总大小
    int totalSize = logs.length + _pendingLogs.length;
    if (totalSize > maxBuffer) {
      int overflow = totalSize - maxBuffer;
      // 优先删除 logs 里最老的
      if (overflow > 0) {
        int removeFromLogs = min(overflow, logs.length);
        if (removeFromLogs > 0) {
          logs.removeRange(0, removeFromLogs);
          overflow -= removeFromLogs;
        }
      }
      // 如果还不够，就从 pending 里删除最老的
      if (overflow > 0 && _pendingLogs.isNotEmpty) {
        int removeFromPending = min(overflow, _pendingLogs.length);
        _pendingLogs.removeRange(0, removeFromPending);
      }
    }
  }

  void addLog(String log) {
    _pendingLogs.add(log);
  }

  void clearLog() {
    logs.clear();
    _pendingLogs.clear();
  }

  void copyLogs() {
    final allLogs = logs.join("");
    Clipboard.setData(ClipboardData(text: allLogs));
    Get.snackbar(I18n.tip.tr, I18n.copy_success.tr,
        duration: const Duration(seconds: 1));
  }

  void toggleAutoScroll() {
    autoScroll.value = !autoScroll.value;
    if (autoScroll.value) {
      scrollLogs?.call(force: true, scrollOffset: -1);
    }
  }

  void toggleCollapse() => collapseLog.value = !collapseLog.value;

  double get savedScrollOffsetVal => _savedScrollOffset;
  void saveScrollOffset(double offset) {
    _savedScrollOffset = offset;
  }
}
