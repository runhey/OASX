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

  Future<void> switchScript(int val) async {
    if (val == selectedIndex.value) {
      return;
    }
    // 切换二级菜单的
    if (val == 0) {
      selectedMenu.value = 'Home';
      isHomeMenu.value = true;
    } else {
      selectedMenu.value = 'Overview';
      isHomeMenu.value = false;
    }

    // 切换导航栏的
    selectedIndex.value = val;
    // ignore: invalid_use_of_protected_member
    selectedScript.value = scriptName.value[val];

    // 注册控制器的
    if (!Get.isRegistered<OverviewController>(tag: selectedScript.value) &&
        val != 0) {
      Get.put(
          tag: selectedScript.value,
          permanent: true,
          OverviewController(name: selectedScript.value));
    }
  }

  // 获取能够有内容的二级菜单
  List<String> get useablemenus {
    List<String> getuseablemenus() {
      List<String> result = [];
      homeMenuJson.forEach((key, value) {
        if (value.isNotEmpty) {
          result.addAll(value);
        } else {
          result.add(key);
        }
      });
      scriptMenuJson.forEach((key, value) {
        if (value.isNotEmpty) {
          result.addAll(value);
        } else {
          result.add(key);
        }
      });
      return result;
    }

    _useablemenus = getuseablemenus();
    printInfo(info: _useablemenus.toString());
    return _useablemenus!;
  }

  void switchContent(String val) {
    if (!useablemenus.contains(val)) {
      return;
    }
    selectedMenu.value = val;

    // args的切换
    if (val == 'Home' ||
        val == 'Overview' ||
        val == 'Updater' ||
        val == 'Tool') {
      return;
    }
    if (selectedScript.value == 'Home') {
      return;
    }
    ArgsController argsController = Get.find();
    argsController.loadGroups(config: selectedScript.value, task: val);
  }
}
