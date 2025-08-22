part of server;

class ServerController extends GetxController with LogMixin {
  final rootPathServer = ''.obs;
  final rootPathAuthenticated = true.obs;
  final showDeploy = true.obs;

  final log = ''.obs;
  final deployContent = ''.obs;
  Shell? shell;
  var shellController = ShellLinesController();

  @override
  void onInit() {
    rootPathServer.value =
        Get.find<SettingsController>().storage.read('rootPathServer') ??
            'Please set OAS root path';
    shell = getShell;
    shellController.stream.listen((event) {
      addLog('INFO: $event');
    });
    rootPathAuthenticated.value = authenticatePath(rootPathServer.value);
    if (rootPathAuthenticated.value) {
      readDeploy();
    }
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

  void run() {
    clearLog();
    shell!.kill();
    runShell('echo OAS working directory: ').then((value) => null);
    runShell('pwd').then((value) => null);
    // runShell('(type env:path) -split ; ').then((value) => null);
    runShell('python -m deploy.installer').then((value) => null);
    runShell('echo Start OAS').then((value) => null);
    runShell('taskkill /f /t /im pythonw.exe').then((value) => null);
    runShell(".\\toolkit\\pythonw.exe  server.py").then((value) => null);
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
