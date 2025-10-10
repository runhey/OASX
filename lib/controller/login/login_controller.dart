part of login;

class LoginController extends GetxController {
  static bool logined = false;
  var username = ''.obs;
  var password = ''.obs;
  var address = ''.obs;

  GetStorage storage = GetStorage();

  @override
  Future<void> onInit() async {
    username.value = storage.read(StorageKey.username.name) ?? "";
    password.value = storage.read(StorageKey.password.name) ?? "";
    address.value = storage.read(StorageKey.address.name) ?? "";
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    if (address.value.isEmpty || logined) return;
    final settingsController = Get.find<SettingsController>();
    if (settingsController.autoDeploy.value) {
      Get.snackbar(I18n.tip.tr, I18n.auto_deploy.tr,
          showProgressIndicator: true, duration: const Duration(minutes: 1));
      if (!Get.isRegistered<ServerController>()) {
        Get.put<ServerController>(ServerController());
      }
      await Get.find<ServerController>().run();
    }
    logined = true;
    await login(address.value,
        retries: settingsController.autoDeploy.value ? 10 : 1);
    super.onReady();
  }

  /// 进入主页面
  Future<void> toMain({required Map<String, dynamic> data}) async {
    storage.write(StorageKey.username.name, data['username']);
    storage.write(StorageKey.password.name, data['password']);
    storage.write(StorageKey.address.name, data['address']);
    printInfo(info: data.toString());
    await login(data['address']);
  }

  Future<void> login(String address, {int retries = 1}) async {
    ApiClient().setAddress('http://$address');
    for (int i = 0; i < retries; ++i) {
      if (await ApiClient().testAddress()) {
        await Get.closeCurrentSnackbar();
        Get.offAllNamed('/main');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
