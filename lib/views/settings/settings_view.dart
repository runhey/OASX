library settings;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:oasx/config/global.dart';
import 'package:oasx/controller/settings.dart';
import 'package:oasx/service/locale_service.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/service/theme_service.dart';
import 'package:oasx/service/window_service.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/views/home/tool_view.dart';
import 'package:oasx/views/home/updater_view.dart';
import 'package:oasx/views/settings/widgets/setting_card.dart';
import 'package:oasx/views/settings/widgets/setting_item.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';
import 'package:oasx/utils/platform_utils.dart';

part 'oas_card.dart';
part 'system_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const double minCardWidth = 400;
  static const double spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPlatformAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const cards = [
            SystemSettingsCard(),
            OasSettingsCard(),
          ];
          return MasonryGridView.count(
            crossAxisCount: getCrossCnt(constraints),
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            itemCount: cards.length,
            itemBuilder: (context, index) => cards[index],
          ).paddingOnly(left: 8, right: 8, top: 8);
        },
      ),
    );
  }

  // 获取一行卡片数量,最少1个最多4个
  int getCrossCnt(BoxConstraints constraints) {
    final crossAxisCount =
        (constraints.maxWidth / (minCardWidth + spacing)).floor().clamp(1, 4);
    return crossAxisCount;
  }
}
