import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oasx/translation/i18n_content.dart';

mixin LogMixin on GetxController {
  final ScrollController scrollController = ScrollController();

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

  /// before dispose offset
  final savedScrollOffset = 0.0.obs;

  @override
  void onInit() {
    _refreshTimer ??=
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_pendingLogs.isEmpty) {
        return;
      }
      _clearOverflowLogs();
      _updateUILogs();
      _removeUIOldLogs();
      _scrollLogs();
    });
    super.onInit();
  }

  void _scrollLogs({isJump = false, force = false, scrollOffset = -1}) {
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      // 强制滚动或自动滚动才允许滚动
      if (!force && !autoScroll.value) return;
      final double targetPos = scrollOffset == -1
          ? scrollController.position.maxScrollExtent
          : scrollOffset;
      if (isJump) {
        scrollController.jumpTo(targetPos);
        return;
      }
      final double currentPos = scrollController.offset;
      final double distance = (targetPos - currentPos).abs();
      // 使用非线性函数计算动画时间
      // sqrt: 小距离变化快 大距离变化平缓
      // 1000px 大约 400ms,10000px 大约 1200ms
      int animateMs = (sqrt(distance) * 12).toInt();
      const int minAnimateMs = 100; // 最快速度
      const int maxAnimateMs = 1500; // 最慢速度
      // 限制范围
      animateMs = animateMs.clamp(minAnimateMs, maxAnimateMs);
      scrollController.animateTo(targetPos,
          duration: Duration(milliseconds: animateMs), curve: Curves.easeOut);
    });
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
    int burst = (backlog ~/ 100).clamp(minBurst, maxBurst);
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

  @override
  void onClose() {
    _refreshTimer?.cancel();
    scrollController.dispose();
    super.onClose();
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
    _scrollLogs();
  }

  void toggleCollapse() => collapseLog.value = !collapseLog.value;

  void handleUserScroll() {
    if (!scrollController.hasClients) return;
    final atBottom = scrollController.offset >=
        (scrollController.position.maxScrollExtent - 80);
    autoScroll.value = atBottom;
  }

  void saveScrollOffset() {
    if (scrollController.hasClients && !autoScroll.value) {
      savedScrollOffset.value = scrollController.offset;
    }
  }

  void restoreScrollOffset() {
    if (!autoScroll.value && savedScrollOffset.value > 0) {
      _scrollLogs(force: true, scrollOffset: savedScrollOffset.value);
      return;
    }
    _scrollLogs(force: true);
  }
}
