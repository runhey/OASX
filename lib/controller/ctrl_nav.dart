part of nav;

class NavCtrl extends GetxController {
  final scriptName = <String>['Home', 'oas1'].obs; // 列表
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
  var scriptMenuJson = <String, List<String>>{
    'Script': ['Script', 'Restart', 'GlobalGame'],
    "Soul Zones": [
      'Orochi',
      'Sougenbi',
      'FallenSun',
      'EternitySea',
      'SixRealms'
    ],
    "Daily Task": [
      'DailyTrifles',
      'AreaBoss',
      'GoldYoukai',
      'ExperienceYoukai',
      'Nian',
      'TalismanPass',
      'DemonEncounter',
      'Pets',
      'SoulsTidy',
      'Delegation',
      'WantedQuests',
      'Tako'
    ],
    "Liver Emperor Exclusive": [
      'BondlingFairyland',
      'EvoZone',
      'GoryouRealm',
      'Exploration',
      'Hyakkiyakou'
    ],
    "Guild": [
      'KekkaiUtilize',
      'KekkaiActivation',
      'RealmRaid',
      'RyouToppa',
      'Dokan',
      'CollectiveMissions',
      'Hunt'
    ],
    "Weekly Task": [
      'TrueOrochi',
      'RichMan',
      'Secret',
      'WeeklyTrifles',
      'MysteryShop',
      'Duel'
    ],
    "Activity Task": [
      'ActivityShikigami',
      'MetaDemon',
      'FrogBoss',
      'FloatParade'
    ],
  }.obs;

  List<String>? _useablemenus;

  @override
  Future<void> onInit() async {
    await ApiClient().putChineseTranslate();
    // 异步获取所有的实例
    // ignore: invalid_use_of_protected_member
    scriptName.value = await ApiClient().getConfigList();

    ApiClient().getHomeMenu().then((model) {
      homeMenuJson.value = model;
    });
    ApiClient().getScriptMenu().then((model) {
      scriptMenuJson.value = model;
    });

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    useablemenus;
    super.onReady();
  }

  Future<void> switchScript(int idx) async {
    if (idx == selectedIndex.value && scriptName[idx] == selectedScript.value) {
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
    selectedScript.value = scriptName[idx];

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

  Future<void> deleteConfig(String name) async {
    final int idx = scriptName.indexOf(name);
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
    scriptName.removeAt(idx);

    if (idx < selectedIndex.value) {
      // deleted script is before selected script, change selected script index
      selectedIndex.value -= 1;
    } else if (idx == selectedIndex.value) {
      // deleted script is selected
      if (idx < scriptName.length) {
        // not end script, select next script
        switchScript(idx);
      } else {
        // end script, select previous script
        switchScript(idx - 1);
      }
    }
  }

  Future<void> renameConfig(String oldName, String newName) async {
    final int idx = scriptName.indexOf(oldName);
    if (idx == -1) return;
    // rename remote config
    if (!await ApiClient().renameConfig(oldName, newName)) return;
    // rename local config
    scriptName[idx] = newName;
    // force delete controller and register new one
    try {
      // when delete, ws can auto close, so force delete controller
      Get.delete<OverviewController>(tag: oldName, force: true);
    } catch (_) {}
    // reactive new controller on current idx
    if (idx == selectedIndex.value) {
      switchScript(idx);
      return;
    }
    Get.put(tag: newName, permanent: true, OverviewController(name: newName));
  }
}
