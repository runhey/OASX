part of nav;

class NavCtrl extends GetxController {
  final scriptName = <String>['Home', 'template'].obs; // 列表
  final selectedIndex = 0.obs;
  final selectedScript = 'Home'.obs; // 当前选中的名字
  final selectedMenu = 'Home'.obs; // 当前选中的第二级名字

  final testTree = true.obs;

  @override
  Future<void> onInit() async {
    // 异步获取所有的实例
    // ignore: invalid_use_of_protected_member
    scriptName.value = await ApiClient().getConfigList();

    super.onInit();
  }

  List<String> testScriptName() =>
      <String>['Home', 'First', 'Second', 'Third', 'Fourth'];

  Future<void> switchScript(int val) async {
    if (val == selectedIndex.value) {
      return;
    }
    // 切换子菜单的
    NavMenuController navMenuController = Get.find();
    if (val == 0) {
      selectedMenu.value = 'Home';
      //navMenuController.treeData.value = navMenuController.homeData;
    } else {
      selectedMenu.value = 'Overview';
      //navMenuController.treeData.value = navMenuController.scriptData;
    }

    // 切换导航栏的
    selectedIndex.value = val;
    // ignore: invalid_use_of_protected_member
    selectedScript.value = scriptName.value[val];
    if (val == 0) {
      navMenuController.treeData.value = navMenuController.homeData;
      navMenuController.treeModel.value = navMenuController.homeModel;
      navMenuController.isHomeMenu.value = true;
      printInfo(info: '现在是Home${navMenuController.isHomeMenu.value}');
    } else {
      navMenuController.treeData.value = navMenuController.scriptData;
      navMenuController.treeModel.value = navMenuController.scriptModel;
      navMenuController.isHomeMenu.value = false;
      printInfo(info: '现在是Script${navMenuController.isHomeMenu.value}');
    }
    // printInfo(info: navMenuController.treeData.toString());
    testTree.value = !testTree.value;

    // 注册控制器的
    if (!Get.isRegistered<OverviewController>(tag: selectedScript.value) &&
        val != 0) {
      Get.put(tag: selectedScript.value, permanent: true, OverviewController());
    }
  }

  void switchContent(String val) {
    // 输入验证
    selectedMenu.value = val;
  }
}
