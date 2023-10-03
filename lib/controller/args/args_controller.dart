part of args;

class ArgsController extends GetxController {
  final groups = Rx<List<GroupsModel>>([]);

  @override
  void onInit() {
    File jsonFile = File('./lib/controller/args/task.json'); // 替换为您的 JSON 文件路径
    String jsonString = jsonFile.readAsStringSync();
    loadModelfromStr(jsonString);
    super.onInit();
  }

  void loadModel(Map<String, dynamic> json) {
    groups.value = [];
    json.forEach((key, value) {
      groups.value.add(GroupsModel(groupName: key, data: value));
    });
  }

  void loadModelfromStr(String json) {
    loadModel(jsonDecode(json));
  }
}

class GroupsModel {
  final String groupName;
  List<dynamic>? members;

  /// 把 json对象转化为 model
  GroupsModel({required this.groupName, required data}) {
    data.map((e) => {
          print(e),
          if (e["type"] == "integer")
            {members?.add(Integer.fromJson(e))}
          else if (e["type"] == "string")
            {members?.add(PurpleString.fromJson(e))}
          else if (e["type"] == "boolean")
            {members?.add(Boolean.fromJson(e))}
          else if (e["type"] == "number")
            {members?.add(Number.fromJson(e))}
          else if (e["type"] == "enum")
            {members?.add(Enum.fromJson(e))}
        });
  }

  // GroupsModel.fromJson(this.members,
  //     {required this.groupName, required List<dynamic> data}) {
  //   data.map((e) => {
  //         print(e),
  //         if (e["type"] == "integer")
  //           {members.add(Integer.fromJson(e))}
  //         else if (e["type"] == "string")
  //           {members.add(PurpleString.fromJson(e))}
  //         else if (e["type"] == "boolean")
  //           {members.add(Boolean.fromJson(e))}
  //         else if (e["type"] == "number")
  //           {members.add(Number.fromJson(e))}
  //         else if (e["type"] == "enum")
  //           {members.add(Enum.fromJson(e))}
  //       });
  // }
}
