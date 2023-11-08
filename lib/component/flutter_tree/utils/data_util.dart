import '../flutter_tree.dart';

// copy from https://github.com/Invincible1996/flutter_tree

class DataUtil {
  /// @params
  /// @desc  List to map
  static Map<String, dynamic> transformListToMap(List dataList, Config config) {
    Map obj = {};
    int? rootId;
    dataList.forEach((v) {
      // 根节点
      if (v[config.parentId] != 0) {
        if (obj[v[config.parentId]] != null) {
          if (obj[v[config.parentId]][config.children] != null) {
            obj[v[config.parentId]][config.children].add(v);
          } else {
            obj[v[config.parentId]][config.children] = [v];
          }
        } else {
          obj[v[config.parentId]] = {
            config.children: [v],
          };
        }
      } else {
        rootId = v[config.id];
      }
      if (obj[v[config.id]] != null) {
        v[config.children] = obj[v[config.id]][config.children];
      }
      obj[v[config.id]] = v;
    });
    return obj[rootId] ?? {};
  }

  /// @params
  /// @desc expand tree map
  Map<String, dynamic> expandMap(Map<String, dynamic> dataMap, Config config) {
    dataMap['open'] = false;
    dataMap['checked'] = 0;
    dataMap.putIfAbsent(dataMap[config.id], () => dataMap);
    (dataMap[config.children] ?? []).forEach((element) {
      expandMap(element, config);
    });
    return {"aaa": ""};
  }

  /// @params
  /// @desc 将树形结构数据平铺开
  // factoryTreeData(treeModel ,Config config) {
  //   treeModel['open'] = false;
  //   treeModel['checked'] = 0;
  //   treeMap.putIfAbsent(treeModel[config.id], () => treeModel);
  //   (treeModel[config.children] ?? []).forEach((element) {
  //     factoryTreeData(element);
  //   });
  // }
}
