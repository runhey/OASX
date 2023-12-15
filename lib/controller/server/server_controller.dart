part of server;

class ServerController extends GetxController {
  final rootPathServer = ''.obs;
  final rootPathAuthenticated = true.obs;
  final running = false.obs;

  @override
  void onInit() {
    rootPathServer.value =
        Get.find<SettingsController>().storage.read('rootPathServer') ??
            'Please set OAS root path';
    rootPathAuthenticated.value = authenticatePath(rootPathServer.value);
    super.onInit();
  }

  void updateRootPathServer(String value) {
    if (authenticatePath(value)) {
      rootPathAuthenticated.value = true;
    } else {
      rootPathAuthenticated.value = false;
    }
    rootPathServer.value = value;
    Get.find<SettingsController>()
        .storage
        .write('rootPathServer', rootPathServer.value);
  }

  bool authenticatePath(String root) {
    root.replaceAll('\\', '/');
    try {
      // 先是判断根目录
      Directory rootDir = Directory(root);
      if (!rootDir.existsSync()) {
        return false;
      }
      // 然后是判断python是否存在
      File python = File('${rootDir.path}/toolkit/python.exe');
      if (!python.existsSync()) {
        return false;
      }
      // 然后判断git是否存在
      File git = File('${rootDir.path}/toolkit/Git/cmd/git.exe');
      if (!git.existsSync()) {
        return false;
      }
      // 然后判断安装器是否存在
      File installer = File('${rootDir.path}/deploy/installer.py');
      if (!installer.existsSync()) {
        return false;
      }
      // 然后判断deploy是否存在
      File deploy = File('${rootDir.path}/config/deploy.yaml');
      if (!deploy.existsSync()) {
        return false;
      }
    } catch (e) {
      printError(info: e.toString());
      return false;
    }
    printInfo(info: '都是zhe');

    return true;
  }
}
