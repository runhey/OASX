part of nav_menu;

class NavMenuController extends GetxController {
  final isHomeMenu = true.obs;
  final treeData = Rx<List<TreeNodeData>>([]); // 最终显示的数据
  final homeData =
      ScriptMenuModel.fromJson(Get.find<SettingsController>().readHomeMenu())
          .toTreeData();
  final scriptData =
      ScriptMenuModel.fromJson(Get.find<SettingsController>().readScriptMenu())
          .toTreeData();

  final treeModel =
      ScriptMenuModel.fromJson(Get.find<SettingsController>().readHomeMenu())
          .obs;
  final homeModel = ScriptMenuModel.fromJson({'Home': []});
  final scriptModel = ScriptMenuModel.fromJson({'Yyyy': []});

  final serverData = [
    {
      "checked": true,
      "children": [
        {
          "checked": true,
          "show": false,
          "children": [],
          "id": 11,
          "pid": 1,
          "text": "Overview",
        },
      ],
      "id": 1,
      "pid": 0,
      "show": false,
      "text": "Overview",
    },
    {
      "checked": true,
      "show": false,
      "children": [],
      "id": 2,
      "pid": 0,
      "text": "Parent title 2",
    },
    {
      "checked": true,
      "children": [],
      "id": 3,
      "pid": 0,
      "show": true,
      "text": "Parent title 3",
    },
  ];

  @override
  void onInit() {
    treeData.value = scriptData;
    //ScriptMenuModel.fromJson({'Home': [], 'Updater': []}).toTreeData();

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    // ScriptMenuModel scriptMenuModel = await ApiClient().getScriptMenu();

    // ScriptMenuModel homeMenuModel = await ApiClient().getHomeMenu();
    // treeData.value = homeMenuModel.toTreeData();
    super.onReady();
  }

  TreeNodeData mapServerDataToTreeData(Map data) {
    return TreeNodeData(
      extra: data,
      title: data['text'],
      expanded: data['show'],
      checked: data['checked'],
      children:
          List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
    );
  }
}
