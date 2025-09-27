import 'package:get/get.dart';

class ProgressDialogItemState {
  final name = ''.obs;
  final progress = 0.0.obs;

  ProgressDialogItemState(String name, double progress) {
    this.name.value = name;
    this.progress.value = progress;
  }
}

class ProgressDialogController extends GetxController {
  final title = ''.obs;
  final itemList = <ProgressDialogItemState>[].obs;
  final showCloseButton = false.obs;

  void updateProgress(String name, double progress) {
    itemList.firstWhere((item) => item.name.value == name).progress.value =
        progress.clamp(0, 1);
    update();
  }
}
