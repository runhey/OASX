part of args;

class ArgsController extends GetxController {
  final groups = Rx<List<GroupsModel>>([]);
  final groupsName = Rx<List<String>>([]);
  final groupsData = Rx<Map<String, GroupsModel>>({});
  static const String schedulerGroup = 'scheduler';

  @override
  void onInit() {
    // loadGroups();
    super.onInit();
  }

  void loadModel(Map<String, dynamic> json) {
    groups.value = [];
    json.forEach((key, value) {
      groups.value.add(GroupsModel(groupName: key, members: value));
    });
  }

  void loadModelfromStr(String json) {
    loadModel(jsonDecode(json));
  }

  /// 加载groups数据
  Future<void> loadGroups({String config = "", String task = ""}) async {
    // 清空缓存数据
    groupsName.value = [];
    groupsData.value = {};
    List<String> groupsNameTemp = [];

    var json = await ApiClient().getScriptTask(config, task);
    // 更新groupsData
    // 更新groupsName
    for (var entry in json.entries) {
      groupsNameTemp.add(entry.key);
      List<ArgumentModel> arguments = [];
      for (var argument in entry.value) {
        arguments.add(ArgumentModel.fromJson(argument));
      }
      groupsData.value[entry.key] =
          GroupsModel(groupName: entry.key, members: arguments);
    }
    groupsName.value = groupsNameTemp;
  }

  Future<void> setArgument(String? config, String? task, String? group,
      String argument, String type, var value) async {
    if (config == null || task == null || group == null) {
      return;
    }
    if (config.isEmpty || task.isEmpty || group.isEmpty) {
      NavCtrl navCtrl = Get.find();
      config = navCtrl.selectedScript.value;
      task = navCtrl.selectedMenu.value;
    }
    await ApiClient().putScriptArg(config, task, group, argument, type, value);
    // 设置的是调度器的内容,则自动更新调度器
    if (group == schedulerGroup) {
      await Get.find<WebSocketService>().send(config, 'get_schedule');
    }
  }
}

class GroupsModel {
  final String groupName;
  List<dynamic> members;

  /// 把 json对象转化为 model
  GroupsModel({required this.groupName, required this.members});

  String getGroupName() => groupName;
}

class ArgumentModel {
  final String title;
  dynamic value;
  final String type;

  final String? description;

  final List<String>? enumEnum;
  final dynamic minimum;
  final dynamic maximum;
  final dynamic defaultValue;

  ArgumentModel(
    this.enumEnum,
    this.minimum,
    this.maximum,
    this.defaultValue,
    this.description, {
    required this.title,
    required this.value,
    required this.type,
  });

  factory ArgumentModel.fromJson(Map<String, dynamic> json) {
    return ArgumentModel(
        List<String>.from(json["enumEnum"]?.map((x) => x) ?? []),
        json['minimum'],
        json['maximum'],
        json['defaultValue'],
        json['description'],
        title: json['name'] as String,
        value: json['value'],
        type: json['type'] as String);
  }

  set setValue(dynamic newValue) => value = newValue;
}
