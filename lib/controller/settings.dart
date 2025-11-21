import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/config/translation/i18n_content.dart';
import 'package:oasx/views/nav/view_nav.dart';
import 'package:path_provider/path_provider.dart';

import 'package:oasx/utils/check_version.dart';
import 'package:oasx/config/global.dart';

/// language: String ["en-US", "zh-CN", "zh-TW", "ja-JP"]
/// 关于桌面分辨率的适配： 不知道如何下手
class SettingsController extends GetxController {
  GetStorage storage = GetStorage();
  late String temporaryDirectory;

  @override
  void onInit() {
    updateTemporaryDirectory();
    getCurrentVersion().then((value) {
      GlobalVar.version = value;
    });
    super.onInit();
  }

  void updateTemporaryDirectory() {
    temporaryDirectory = storage.read('temporaryDirectory') ?? './';
    printInfo(info: 'Old TemporaryDirectory : $temporaryDirectory');
    getTemporaryDirectory().then((value) {
      temporaryDirectory = value.path;
      printInfo(info: 'New TemporaryDirectory : $temporaryDirectory');
      storage.write('temporaryDirectory', temporaryDirectory);
    });
  }

  Future<void> killServer() async {
    final success = await ApiClient().killServer();
    if (success) {
      Get.snackbar(I18n.kill_server_success.tr, '');
      Get.offAllNamed('/login');
      await Future.wait([
        Get.delete<ScriptService>(force: true),
        Get.delete<NavCtrl>(force: true),
      ]);
    } else {
      Get.snackbar(I18n.kill_server_failure.tr, '');
    }
  }
}
