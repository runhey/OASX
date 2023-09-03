part of args;

class ArgsController extends GetxController {
  final groups = Rx<List<GroupsModel>>([]);

  @override
  void onInit() {
    super.onInit();
  }

  void loadModel(Map<String, dynamic> json) {
    json.forEach((key, value) {
      groups.value.add(GroupsModel(groupName: key, data: value));
    });
  }

  void loadModelfromStr(String json) {
    loadModel(jsonDecode(json));
  }
}

class GroupsModel {
  final String? groupName;
  late List<dynamic> members;

  /// 把 json对象转化为 model
  GroupsModel({required this.groupName, required List<dynamic> data}) {
    data.map((e) => {
          if (e["type"] == "integer")
            {members.add(Integer.fromJson(e))}
          else if (e["type"] == "string")
            {members.add(PurpleString.fromJson(e))}
          else if (e["type"] == "boolean")
            {members.add(Boolean.fromJson(e))}
          else if (e["type"] == "number")
            {members.add(Number.fromJson(e))}
          else if (e["type"] == "enum")
            {members.add(Enum.fromJson(e))}
        });
  }
}
