import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:oasx/views/nav/view_nav.dart';
import 'package:path_provider/path_provider.dart';

import 'package:oasx/utils/check_version.dart';
import 'package:oasx/config/global.dart';

/// language: String ["en-US", "zh-CN", "zh-TW", "ja-JP"]
/// 关于桌面分辨率的适配： 不知道如何下手
class SettingsController extends GetxController {
  GetStorage storage = GetStorage();
  late String temporaryDirectory;
  final autoLoginAfterDeploy = false.obs;
  final autoDeploy = false.obs;

  @override
  void onInit() {
    autoLoginAfterDeploy.value =
        storage.read(StorageKey.autoLoginAfterDeploy.name) ?? false;
    updateTemporaryDirectory();
    getCurrentVersion().then((value) {
      GlobalVar.version = value;
    });
    autoDeploy.value = (storage.read(StorageKey.autoDeploy.name) ?? false) &&
        PlatformUtils.isDesktop;
    super.onInit();
  }

  void updateTemporaryDirectory() {
    temporaryDirectory =
        storage.read(StorageKey.temporaryDirectory.name) ?? './';
    printInfo(info: 'Old TemporaryDirectory : $temporaryDirectory');
    getTemporaryDirectory().then((value) {
      temporaryDirectory = value.path;
      printInfo(info: 'New TemporaryDirectory : $temporaryDirectory');
      storage.write(StorageKey.temporaryDirectory.name, temporaryDirectory);
    });
  }

  void updateAutoLoginAfterDeploy(bool nv) {
    autoLoginAfterDeploy.value = nv;
    storage.write(StorageKey.autoLoginAfterDeploy.name, nv);
  }

  Future<void> killServer({bool showTip = true}) async {
    final success = await ApiClient().killServer();
    if (success) {
      if(showTip) Get.snackbar(I18n.kill_server_success.tr, '');
      await resetClient();
    } else {
      if(showTip) Get.snackbar(I18n.kill_server_failure.tr, I18n.kill_server_failure_msg.tr);
    }
  }

  // 重置客户端环境
  Future<void> resetClient() async {
    await Future.wait([
      Get.delete<ScriptService>(force: true),
      Get.delete<NavCtrl>(force: true),
    ]);
  }

  void updateAutoDeploy(bool nv) {
    autoDeploy.value = nv;
    storage.write(StorageKey.autoDeploy.name, nv);
  }
}
