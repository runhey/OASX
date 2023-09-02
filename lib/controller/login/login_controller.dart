part of login;

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var address = ''.obs;

  GetStorage storage = GetStorage();

  @override
  void onInit() {
    username.value = storage.read('username') ?? "";
    password.value = storage.read('password') ?? "";
    address.value = storage.read('address') ?? "";
    super.onInit();
  }

  /// 进入主页面, TODO: 进入之前确认是否可以连接服务器
  void toMain({required Map<String, dynamic> data}) {
    storage.write('username', data['username']);
    storage.write('password', data['password']);
    storage.write('address', data['address']);
    printInfo(info: data.toString());
    Get.offAllNamed('/main');
  }

  // @override
  // void onClose() {
  //   printInfo(info: 'onClose');
  //   super.onClose();
  // }
}
