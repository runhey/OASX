part of nav;

class NavCtrl extends GetxController {
  final scriptName = <String>['Home', 'template'].obs; // 列表
  final selectedIndex = 0.obs;
  final selectedScript = 'Home'.obs; // 当前选中的名字
  final selectedMenu = 'Home'.obs; // 当前选中的第二级名字

  @override
  Future<void> onInit() async {
    // 异步获取所有的实例
    // ignore: invalid_use_of_protected_member
    scriptName.value = await ApiClient().getConfigList();

    super.onInit();
  }

  List<String> testScriptName() =>
      <String>['Home', 'First', 'Second', 'Third', 'Fourth'];

  void switchScript(int val) {
    if (val == selectedIndex.value) {
      return;
    }
    if (val == 0) {
      selectedMenu.value = 'Home';
    } else {
      selectedMenu.value = 'Overview';
    }
    selectedIndex.value = val;
    // ignore: invalid_use_of_protected_member
    selectedScript.value = scriptName.value[val];

    if (!Get.isRegistered<OverviewController>(tag: selectedScript.value)) {
      Get.put(tag: selectedScript.value, permanent: true, OverviewController());
    }
  }

  void switchContent(String val) {
    // 输入验证
    selectedMenu.value = val;
  }
}
