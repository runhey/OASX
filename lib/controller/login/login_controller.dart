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
    logined = true;
    // 尝试直接登录, 已经部署了则不再部署
    final loginSuccess = await login(address.value);
    if (loginSuccess) {
      return;
    }
    // 登录失败则部署oas
    final settingsController = Get.find<SettingsController>();
    if (settingsController.autoDeploy.value) {
      Get.snackbar(I18n.tip.tr, I18n.auto_deploy.tr,
          showProgressIndicator: true, duration: const Duration(minutes: 10));
      if (!Get.isRegistered<ServerController>()) {
        Get.put<ServerController>(ServerController());
      }
      await Get.find<ServerController>().run();
    }
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

  Future<bool> login(String address, {int retries = 1}) async {
    ApiClient().setAddress('http://$address');
    for (int i = 0; i < retries; ++i) {
      if (await ApiClient().testAddress()) {
        await Get.closeCurrentSnackbar();
        Get.offAllNamed('/main');
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }
}
