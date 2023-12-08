import 'package:flutter_nb_net/flutter_net.dart';

class UpdateInfoModel extends BaseNetModel {
  @override
  UpdateInfoModel fromJson(Map<String, dynamic> json) {
    return UpdateInfoModel.fromJson(json);
  }

  UpdateInfoModel({
    this.isUpdate,
    this.branch,
    this.currentCommit,
    this.latestCommit,
    this.commit,
  });
  UpdateInfoModel.fromJson(dynamic json) {
    isUpdate = json['is_update'];
    branch = json['branch'];
    currentCommit = json['current_commit']!.cast<String>();
    latestCommit = json['latest_commit']!.cast<String>();
    // commit = 
    //      json['commit']!.map<List<String>>((dynamic e) => e.cast<String>() ).toList();

    commit = [];
    json['commit']!.forEach((e){
      commit!.add(e.cast<String>());
    });

  }                                                                          

  bool? isUpdate;
  String? branch;
  List<String>? currentCommit;
  List<String>? latestCommit;
  List<List<String>>? commit;
}