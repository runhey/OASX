part of nav;

class NavCtrl extends GetxController {
  final scriptName = <String>['Home'].obs;
  final selectedIndex = 0.obs;
  final selectedScript = 'Home'.obs; // 当前选中的名字
  final selectedMenu = 'Home'.obs; // 当前选中的第二级名字

  @override
  void onInit() {
    // 异步获取所有的实例
    scriptName.value = testScriptName();
    // 懒加载每个实例的控制器
    // ignore: invalid_use_of_protected_member
    for (var name in scriptName.value) {
      Get.lazyPut(tag: name, () => NavMenuController());
      Get.lazyPut(tag: name, () => OverviewController());
    }
    super.onInit();
  }

  List<String> testScriptName() =>
      <String>['Home', 'First', 'Second', 'Third', 'Fourth'];

  void switchScript(int val) {
    selectedIndex.value = val;
    // ignore: invalid_use_of_protected_member
    selectedScript.value = scriptName.value[val];
  }
}
