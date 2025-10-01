part of nav;

class NavCtrl extends GetxController {
  final navNameList = <String>['Home', 'oas1'].obs; // 列表
  final selectedIndex = 0.obs;
  final selectedScript = 'Home'.obs; // 当前选中的名字
  final selectedMenu = 'Home'.obs; // 当前选中的第二级名字

  // 二级菜单控制
  final isHomeMenu = true.obs;
  var homeMenuJson = <String, List<String>>{
    'Home': [],
    'Updater': [],
    'Tool': [],
  }.obs;
  var scriptMenuJson = <String, List<String>>{}.obs;

  @override
  Future<void> onInit() async {
    await ApiClient().putChineseTranslate();

    navNameList.value = await ApiClient().getConfigList();
    homeMenuJson.value = await ApiClient().getHomeMenu();
    scriptMenuJson.value = await ApiClient().getScriptMenu();

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    useablemenus;
    super.onReady();
  }

  Future<void> switchScript(int idx) async {
    if (idx == selectedIndex.value &&
        navNameList[idx] == selectedScript.value) {
      return;
    }
    // 切换二级菜单的
    if (idx == 0) {
      selectedMenu.value = 'Home';
      isHomeMenu.value = true;
    } else {
      selectedMenu.value = 'Overview';
      isHomeMenu.value = false;
    }

    // 切换导航栏的
    selectedIndex.value = idx;
    // ignore: invalid_use_of_protected_member
    selectedScript.value = navNameList[idx];

    // 注册控制器的
    if (!Get.isRegistered<OverviewController>(tag: selectedScript.value) &&
        idx != 0) {
      Get.put(
          tag: selectedScript.value,
          permanent: true,
          OverviewController(name: selectedScript.value));
    }
  }

  // 获取能够有内容的二级菜单
  List<String> get useablemenus {
    final result = <String>[];
    void collectMenus(Map<String, List<String>> menuMap) {
      menuMap.forEach((key, value) {
        result.addAll(value.isNotEmpty ? value : [key]);
      });
    }

    collectMenus(homeMenuJson);
    collectMenus(scriptMenuJson);
    if (kDebugMode) {
      printInfo(info: 'useablemenus = $result');
    }
    return result;
  }

  void switchContent(String menu) {
    if (!useablemenus.contains(menu)) {
      return;
    }
    selectedMenu.value = menu;

    // args的切换
    if (['Home', 'Overview', 'Updater', 'Tool'].contains(menu)) {
      return;
    }
    if (selectedScript.value == 'Home') {
      return;
    }
    final argsController = Get.find<ArgsController>();
    argsController.loadGroups(config: selectedScript.value, task: menu);
  }

  Future<void> addConfig(String newName, String templateName) async {
    navNameList.value = await ApiClient().configCopy(newName, templateName);
    Get.find<ScriptService>().addScriptModel(newName);
  }

  Future<void> deleteConfig(String name) async {
    final int idx = navNameList.indexOf(name);
    if (idx == -1) return;
    // delete remote config
    if (!await ApiClient().deleteConfig(name)) return;
    // force delete controller
    if (Get.isRegistered<OverviewController>(tag: name)) {
      try {
        Get.delete<OverviewController>(tag: name, force: true);
      } catch (e) {
        // ignore
      }
    }
    // delete local config
    navNameList.removeAt(idx);
    Get.find<ScriptService>().deleteScriptModel(name);

    if (idx < selectedIndex.value) {
      // deleted script is before selected script, change selected script index
      selectedIndex.value -= 1;
    } else if (idx == selectedIndex.value) {
      // deleted script is selected
      if (idx < navNameList.length) {
        // not end script, select next script
        switchScript(idx);
      } else {
        // end script, select previous script
        switchScript(idx - 1);
      }
    }
  }

  Future<void> renameConfig(String oldName, String newName) async {
    final int idx = navNameList.indexOf(oldName);
    if (idx == -1) return;
    // rename remote config
    if (!await ApiClient().renameConfig(oldName, newName)) return;
    // rename local config
    navNameList[idx] = newName;
    // force delete controller and register new one
    try {
      // when delete, ws can auto close, so force delete controller
      Get.delete<OverviewController>(tag: oldName, force: true);
      Get.find<ScriptService>().deleteScriptModel(oldName);
    } catch (_) {}
    // reactive new controller on current idx
    if (idx == selectedIndex.value) {
      switchScript(idx);
      return;
    }
    Get.put(tag: newName, permanent: true, OverviewController(name: newName));
    Get.find<ScriptService>().addScriptModel(newName);
  }
}
