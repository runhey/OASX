part of server;

class ServerController extends GetxController with LogMixin {
  final rootPathServer = ''.obs;
  final rootPathAuthenticated = true.obs;
  final showDeploy = true.obs;
  final deployContent = ''.obs;
  final autoLoginAfterDeploy = false.obs;
  final isDeployLoading = false.obs;
  final _storage = GetStorage();
  Shell? shell;
  var shellController = ShellLinesController();

  @override
  void onInit() {
    rootPathServer.value = _storage.read(StorageKey.rootPathServer.name) ??
        'Please set OAS root path';
    autoLoginAfterDeploy.value =
        _storage.read(StorageKey.autoLoginAfterDeploy.name) ?? false;
    shell = getShell;
    shellController.stream.listen(
        (event) => addLog(!event.contains('INFO') ? 'INFO: $event' : event));
    rootPathAuthenticated.value = authenticatePath(rootPathServer.value);
    if (rootPathAuthenticated.value) readDeploy();
    super.onInit();
  }

  void updateRootPathServer(String value) {
    if (authenticatePath(value)) {
      rootPathAuthenticated.value = true;
    } else {
      rootPathAuthenticated.value = false;
    }
    // value = value.replaceAll('\\', '\\\\');
    rootPathServer.value = value;
    shell = getShell;
    Get.find<SettingsController>()
        .storage
        .write('rootPathServer', rootPathServer.value);
    if (rootPathAuthenticated.value) {
      readDeploy();
    }
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

    return true;
  }

  String get pathGit => '${rootPathServer.value}\\toolkit\\Git\\mingw64\\bin"';
  String get pathPython => '${rootPathServer.value}\\toolkit';
  String get pathAdb =>
      '${rootPathServer.value}\\toolkit\\Lib\\site-packages\\adbutils\\binaries';
  String get pathScripts => '${rootPathServer.value}\\toolkit\\Scripts';
  Map<String, String> get pathPATH => {
        'PATH':
            '${rootPathServer.value},$pathGit,$pathPython,$pathAdb,$pathScripts'
      };
  Shell get getShell => Shell(
        workingDirectory: rootPathServer.value,
        runInShell: true,
        environment: pathPATH,
        stdout: shellController.sink,
        verbose: false,
      );

  Future<void> runShell(String command) async {
    try {
      var result = await shell!.run(command);
      printInfo(info: result.errText);
    } on ShellException catch (e) {
      addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> run() async {
    isDeployLoading.value = true;
    if (Get.isRegistered<SettingsController>()) {
      await Get.find<SettingsController>().killServer(showTip: false);
    }
    clearLog();
    shell!.kill();
    await runShell('echo OAS working directory: ');
    await runShell('pwd');
    printInfo(info: 'kill pythonw');
    await runShell('taskkill /f /t /im pythonw.exe');
    printInfo(info: 'kill pythonw finished');
    printInfo(info: 'start deploy');
    await runShell('python -m deploy.installer');
    printInfo(info: 'start deploy finished');
    await runShell('echo Start OAS');
    printInfo(info: 'start server');
    // 非阻塞启动web服务
    runShell(".\\toolkit\\pythonw.exe  server.py");
    if (!autoLoginAfterDeploy.value) {
      isDeployLoading.value = false;
      return;
    }
    // 部署后自动登录
    final address = _storage.read(StorageKey.address.name) ?? "";
    if (address == '') return;
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () async {
      await Get.find<LoginController>().login(address, retries: 10);
      isDeployLoading.value = false;
    });
  }

  void readDeploy() {
    String filePath = '${rootPathServer.value}\\config\\deploy.yaml';
    try {
      File file = File(filePath);
      if (file.existsSync()) {
        deployContent.value = file.readAsStringSync();
        return;
      } else {
        deployContent.value = 'File not found';
        return;
      }
    } catch (e) {
      deployContent.value = 'Error reading file: $e';
      return;
    }
  }

  void writeDeploy(String value) {
    String filePath = '${rootPathServer.value}\\config\\deploy.yaml';
    deployContent.value = value;
    try {
      File file = File(filePath);
      if (file.existsSync()) {
        file.writeAsStringSync(deployContent.value);
        return;
      } else {
        deployContent.value = 'File not found';
        return;
      }
    } catch (e) {
      deployContent.value = 'Error writing file: $e';
      return;
    }
  }
}
