library args;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:expansion_tile_group/expansion_tile_group.dart';

part './group_view.dart';
part '../../controller/args/args_controller.dart';

class Args extends StatelessWidget {
  const Args({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ArgsController>(builder: (controller) {
      return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ExpansionTileGroup(
                      spaceBetweenItem: 10, children: _childrenGroup)
                  .constrained(maxWidth: 700, minWidth: 100))
          .alignment(Alignment.topCenter);
    });
  }

  List<ExpansionTileItem> get _childrenGroup {
    ArgsController controller = Get.find();
    return controller.groupsName.value
        .map((name) => ExpansionTileBorderItem(
              initiallyExpanded: true,
              collapsedBorderColor: Get.theme.colorScheme.secondary,
              expendedBorderColor: Get.theme.colorScheme.outline,
              backgroundColor: Get.theme.colorScheme.primaryContainer,
              title: Text(name),
              children: _children(name),
            ))
        .toList();
  }

  List<Widget> _children(String groupName) {
    ArgsController controller = Get.find();
    GroupsModel groupsModel = controller.groupsData.value[groupName]!;
    List<Widget> result = [const Divider()];
    for (int i = 0; i < groupsModel.members.length; i++) {
      result.add(ArgumentView(
        setArgument: controller.setArgument,
        getGroupName: groupsModel.getGroupName,
        index: i,
      ));
    }
    return result;
  }
}

class ArgumentView extends StatelessWidget {
  final void Function(String? config, String? task, String? group,
      String argument, dynamic value) setArgument;
  final String Function() getGroupName;
  final int index;

  const ArgumentView(
      {required this.setArgument,
      required this.getGroupName,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 350) {
        return Row(
          children: [
            _title(),
            const Spacer(),
            _form(),
          ],
        );
      } else {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_title(), _form()]);
      }
    });
  }

  Widget _title() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        model.title,
        style: Get.textTheme.labelLarge,
      ),
      SelectableText(
        model.description,
        style: Get.textTheme.bodySmall,
      ),
    ]);
  }

  get model {
    ArgsController controller = Get.find();
    GroupsModel? groupsModel = controller.groupsData.value[getGroupName()];
    return groupsModel!.members[index];
  }

  Widget _form() {
    return switch (model.type) {
      "boolean" => Checkbox(value: model.value, onChanged: onCheckboxChanged)
          .alignment(Alignment.centerLeft)
          .constrained(width: 208),
      "string" => TextFormField(
              initialValue: model.value.toString(), onChanged: onStringChanged)
          .constrained(width: 200),
      "number" => TextFormField(
              initialValue: model.value.toString(), onChanged: onNumberChanged)
          .constrained(width: 200),
      "integer" => TextFormField(
              initialValue: model.value.toString(), onChanged: onIntegerChanged)
          .constrained(width: 200),
      "enum" => DropdownButton<String>(
          value: model.value.toString(),
          items: model.enumEnum
                  .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                      value: e.toString(),
                      child: Text(
                        e.toString(),
                      ).constrained(width: 177)))
                  .toList() ??
              [] as List<DropdownMenuItem<String>>,
          onChanged: (String? value) {},
        ),
      _ => Text(model.value.toString()).constrained(width: 200)
    };
  }

  void onCheckboxChanged(bool? value) {
    setArgument("", "", "", "", value);
    model.value = value;
    printInfo(info: "model.value: $model.value");
  }

  void onStringChanged(String? value) {
    setArgument("", "", "", "", value);
  }

  void onNumberChanged(String? value) {
    setArgument("", "", "", "", value);
  }

  void onIntegerChanged(String? value) {
    setArgument("", "", "", "", value);
  }

  void onEnumChanged(String? value) {
    setArgument("", "", "", "", value);
    model.value = value;
  }
}
