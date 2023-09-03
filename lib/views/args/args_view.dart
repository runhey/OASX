library args;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:convert';

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
      return const SizedBox(
        width: 700,
        height: 400,
      );
    });
  }
}
