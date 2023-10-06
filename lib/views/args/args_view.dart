library args;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'dart:async';

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

class ArgumentView extends StatefulWidget {
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
  // ignore: library_private_types_in_public_api
  _ArgumentViewState createState() => _ArgumentViewState();
}

class _ArgumentViewState extends State<ArgumentView> {
  Timer? timer;

  get model {
    ArgsController controller = Get.find();
    GroupsModel? groupsModel =
        controller.groupsData.value[widget.getGroupName()];
    return groupsModel!.members[widget.index];
  }

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
      if (model.description != null && model.description.isNotEmpty)
        SelectableText(
          model.description,
          style: Get.textTheme.bodySmall,
        ),
    ]);
  }

  Widget _form() {
    return switch (model.type) {
      "boolean" => Checkbox(value: model.value, onChanged: onCheckboxChanged)
          .alignment(Alignment.centerLeft)
          .constrained(width: 208),
      "string" => TextFormField(
          initialValue: model.value.toString(),
          onChanged: (value) {
            timer?.cancel();
            timer = Timer(const Duration(milliseconds: 1000),
                () => onStringChanged(value));
          }).constrained(width: 200),
      "number" => TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[-0-9.]')),
          ],
          initialValue: model.value.toString(),
          onChanged: (value) {
            timer?.cancel();
            timer = Timer(const Duration(milliseconds: 1000),
                () => onNumberChanged(value));
          }).constrained(width: 200),
      "integer" => TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[-0-9]')),
          ],
          initialValue: model.value.toString(),
          onChanged: (value) {
            timer?.cancel();
            timer = Timer(const Duration(milliseconds: 1000),
                () => onIntegerChanged(value));
          }).constrained(width: 200),
      "enum" => DropdownButton<String>(
          value: model.value.toString(),
          items: model.enumEnum
                  .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                      value: e.toString(),
                      child: Text(
                        e.toString(),
                        style: Get.textTheme.bodyLarge,
                      ).constrained(width: 177)))
                  .toList() ??
              [] as List<DropdownMenuItem<String>>,
          onChanged: onEnumChanged,
        ),
      _ => Text(model.value.toString()).constrained(width: 200)
    };
  }

  void onCheckboxChanged(bool? value) {
    setState(() {
      widget.setArgument("", "", "", "", value);
      model.value = value;
    });
    showSnakbar(value);
  }

  void onStringChanged(String? value) {
    widget.setArgument("", "", "", "", value);
    showSnakbar(value);
  }

  void onNumberChanged(String? value) {
    widget.setArgument("", "", "", "", value);
    showSnakbar(value);
  }

  void onIntegerChanged(String? value) {
    widget.setArgument("", "", "", "", value);
    showSnakbar(value);
  }

  void onEnumChanged(String? value) {
    setState(() {
      model.value = value;
      widget.setArgument("", "", "", "", value);
    });
    showSnakbar(value);
  }

  void showSnakbar(dynamic value) {
    Get.snackbar("Setting saved", "$value",
        duration: const Duration(seconds: 1));
  }
}
