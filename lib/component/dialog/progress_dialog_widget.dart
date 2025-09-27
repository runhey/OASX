import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/component/dialog/progress_dialog_controller.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:styled_widget/styled_widget.dart';

class ProgressDialogWidget extends StatelessWidget {
  const ProgressDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressDialogController>(
      init: ProgressDialogController(),
      builder: (controller) {
        return <Widget>[
          Text(
            controller.title.value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.itemList.length,
            itemBuilder: (context, index) {
              final item = controller.itemList[index];
              return _ProgressDialogItemWidget(itemState: item);
            },
          ).constrained(maxHeight: 120),
          Obx(() {
            return controller.showCloseButton.value
                ? TextButton(
                    onPressed: () {
                      Get.back();
                      Get.delete<ProgressDialogController>();
                    },
                    child: Text(I18n.confirm.tr,
                        style: Theme.of(context).textTheme.titleMedium),
                  )
                : const SizedBox.shrink();
          })
        ]
            .toColumn(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center)
            .paddingAll(5)
            .constrained(maxWidth: 300)
            .parent(({required Widget child}) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: child));
      },
    );
  }
}

class _ProgressDialogItemWidget extends StatelessWidget {
  const _ProgressDialogItemWidget({required this.itemState});

  final ProgressDialogItemState itemState;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Obx(() {
        return Text(
          itemState.name.value,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis, // 名称过长时显示省略号
          maxLines: 1,
        ).flexible();
      }),
      Obx(() {
        return LinearProgressIndicator(
          value: itemState.progress.value,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          borderRadius: BorderRadius.circular(5),
          minHeight: 8,
        ).expanded();
      }),
      Obx(() {
        return itemState.progress.value == 1
            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
            : Text(
                '${(itemState.progress.value * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelMedium,
              );
      }),
    ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }
}
