part of args;

class ArgsController extends GetxController {
  final groups = Rx<List<GroupsModel>>([]);
  final groupsName = Rx<List<String>>([]);
  final groupsData = Rx<Map<String, GroupsModel>>({});

  @override
  void onInit() {
    File jsonFile = File('./lib/controller/args/task.json'); // 替换为您的 JSON 文件路径
    String jsonString = jsonFile.readAsStringSync();
    loadModelfromStr(jsonString);
    loadGroups();
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
  void loadGroups({String config = "", String task = ""}) {
    // 清空缓存数据
    groupsName.value = [];
    groupsData.value = {};
    List<String> groupsNameTemp = [];
    // 获取groupsName列表
    // 后面可以stream来传回数据
    if (config.isEmpty && task.isEmpty) {
      groupsNameTemp = ['Group1', 'group2', 'YYYYY'];
    }
    // 根据name获取groups数据
    if (config.isEmpty && task.isEmpty) {
      File jsonFile =
          File('./lib/controller/args/task.json'); // 替换为您的 JSON 文件路径
      String jsonString = jsonFile.readAsStringSync();
      jsonDecode(jsonString).forEach(
        (key, value) {
          groupsData.value[key] = GroupsModel(
              groupName: key,
              members: value.map((e) => ArgumentModel.fromJson(e)).toList());
        },
      );
    }

    // push 到Map
    groupsName.value = groupsNameTemp;
  }

  void setArgument(
      String? config, String? task, String? group, String argument, var value) {
    printInfo(
        info:
            "setArgument config: $config, task: $task, group: $group, argument: $argument, value: $value");
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
        title: json['title'] as String,
        value: json['value'],
        type: json['type'] as String);
  }

  set setValue(dynamic newValue) => value = newValue;
}
