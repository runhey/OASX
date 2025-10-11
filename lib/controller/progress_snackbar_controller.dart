import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressSnackbarController extends GetxController
    with GetTickerProviderStateMixin {
  // 进度条动画控制器
  AnimationController? _progressController;
  SnackbarController? _snackbarController;
  final String titleText;
  final messageText = ''.obs;

  ProgressSnackbarController({this.titleText = ''});

  @override
  void onInit() {
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _progressController!.value = 0.0;
    super.onInit();
  }

  @override
  void onClose() {
    _snackbarController?.close();
    _snackbarController = null;
    super.onClose();
  }

  void onSnackbarClosed(SnackbarStatus? status) {
    if (status == SnackbarStatus.CLOSED &&
        Get.isRegistered<ProgressSnackbarController>()) {
      Get.delete<ProgressSnackbarController>();
    }
  }

  Future<void> show() async {
    Get.closeAllSnackbars();
    _snackbarController = null;
    _snackbarController = Get.snackbar(titleText, messageText.value,
        duration: const Duration(days: 1), // 保持不自动消失
        showProgressIndicator: true,
        progressIndicatorController: _progressController,
        messageText: Obx(() => Text(messageText.value)),
        snackbarStatus: onSnackbarClosed);
  }

  void updateProgress(double progress) {
    if (_snackbarController == null || _progressController == null) return;
    _progressController?.value = progress;
  }

  void updateMessage(String message) {
    if (_snackbarController == null) return;
    messageText.value = message;
  }
}
