import 'package:get/get.dart';
import 'progress_dialog_widget.dart';
import 'progress_dialog_controller.dart';

class ProgressDialog {
  static ProgressDialogController get _controller =>
      Get.find<ProgressDialogController>();

  static void show(String title, List<String> contentList) {
    if (!Get.isRegistered<ProgressDialogController>()) {
      Get.put(ProgressDialogController());
    }
    _controller.title.value = title;
    _controller.itemList.value =
        contentList.map((e) => ProgressDialogItemState(e, 0.0)).toList();
    Get.dialog(
      const ProgressDialogWidget(),
      barrierDismissible: false,
    );
  }

  static void update(String name, double progress) async {
    if (!Get.isRegistered<ProgressDialogController>()) return;
    _controller.updateProgress(name, progress);
  }

  static void setConfirm() {
    if (Get.isRegistered<ProgressDialogController>()) {
      _controller.showCloseButton.value = true;
    }
  }
}
