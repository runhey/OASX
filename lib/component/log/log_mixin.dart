import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../comom/i18n_content.dart';

mixin LogMixin on GetxController {
  final ScrollController scrollController = ScrollController();

  /// max lines to store in log
  int get maxLines => 200;

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
  final savedScrollOffset = 0.0.obs;

  @override
  void onInit() {
    _refreshTimer ??=
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_pendingLogs.isEmpty) {
        return;
      }
      // to ui log
      logs.add(_pendingLogs.removeAt(0));
      if (logs.length + 50 > maxLines) {
        logs.removeRange(0, 50);
      }
      // double check to avoid autoScroll's value changed
      if (autoScroll.value && scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (autoScroll.value && scrollController.hasClients) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut);
          }
        });
      }
    });
    super.onInit();
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
    // double check
    if (autoScroll.value && scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (autoScroll.value && scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void toggleCollapse() => collapseLog.value = !collapseLog.value;

  void handleUserScroll() {
    if (!scrollController.hasClients) return;
    final atBottom = scrollController.offset >=
        (scrollController.position.maxScrollExtent - 80);
    if (atBottom) {
      autoScroll.value = true;
    } else {
      autoScroll.value = false;
    }
  }

  void saveScrollOffset() {
    if (scrollController.hasClients && !autoScroll.value) {
      savedScrollOffset.value = scrollController.offset;
    }
  }

  void restoreScrollOffset() {
    int durationMs = 2000;
    if (autoScroll.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          double maxScrollPosition = scrollController.position.maxScrollExtent;
          scrollController.animateTo(maxScrollPosition,
              duration: Duration(
                  milliseconds: min(
                      durationMs, (maxScrollPosition / 1000 * 200).toInt())),
              curve: Curves.easeOut);
        }
      });
      return;
    }
    if (savedScrollOffset.value > 0) {
      printInfo(info: 'restore scroll offset: ${savedScrollOffset.value}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(savedScrollOffset.value,
              duration: Duration(
                  milliseconds: min(durationMs,
                      (savedScrollOffset.value / 1000 * 200).toInt())),
              curve: Curves.easeOut);
        }
      });
    }
  }
}
