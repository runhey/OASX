library args;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:expansion_tile_group/expansion_tile_group.dart';

import 'package:oasx/model/integer.dart';
import 'package:oasx/model/number.dart';
import 'package:oasx/model/string.dart';
import 'package:oasx/model/boolean.dart';
import 'package:oasx/model/enum.dart';

part './group_view.dart';
part '../../controller/args/args_controller.dart';

class Args extends StatelessWidget {
  const Args({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ArgsController>(builder: (controller) {
      return ExpansionTileGroup(spaceBetweenItem: 10, children: _childrenGroup)
          .constrained(maxWidth: 700, minWidth: 100);
    });
  }

  Widget _groupBuilder(BuildContext context, int index) {
    return GroupView(
      index: index,
    );
  }

  List<ExpansionTileItem> get _childrenGroup {
    ArgsController controller = Get.find();
    return controller.groups.value
        .map((group) => ExpansionTileWithoutBorderItem(
              initiallyExpanded: true,
              collapsedBorderColor: Get.theme.colorScheme.secondary,
              expendedBorderColor: Get.theme.colorScheme.outline,
              backgroundColor: Get.theme.colorScheme.primaryContainer,
              title: Text(group.groupName),
              children: const [Text("dddd")],
            ))
        .toList();
  }
}
