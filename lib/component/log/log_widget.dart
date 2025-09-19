import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'log_mixin.dart';

class LogWidget extends StatefulWidget {
  final LogMixin controller;
  final String title;
  final bool? enableCopy;
  final bool? enableAutoScroll;
  final bool? enableClear;
  final bool? enableCollapse;
  final Widget? topPanelBottomChild;

  const LogWidget({
    super.key,
    required this.controller,
    required this.title,
    this.enableCopy,
    this.enableAutoScroll,
    this.enableClear,
    this.enableCollapse,
    this.topPanelBottomChild,
  });

  @override
  State<StatefulWidget> createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> {
  @override
  void initState() {
    super.initState();
    // 延迟一帧再恢复，避免 rebuild 时触发重复动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.restoreScrollOffset();
    });
  }

  @override
  void deactivate() {
    widget.controller.saveScrollOffset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopLogPanel(
          title: widget.title,
          controller: widget.controller,
          enableCopy: widget.enableCopy,
          enableAutoScroll: widget.enableAutoScroll,
          enableClear: widget.enableClear,
          enableCollapse: widget.enableCollapse,
          bottomChild: widget.topPanelBottomChild,
        ),
        Obx(() => widget.controller.collapseLog.value
            ? const SizedBox.shrink()
            : LogContent(controller: widget.controller).expanded()),
      ],
    );
  }
}

/// 日志顶部操作栏
class TopLogPanel extends StatelessWidget {
  final LogMixin controller;
  final String title;
  final bool? enableCopy;
  final bool? enableAutoScroll;
  final bool? enableClear;
  final bool? enableCollapse;
  final Widget? bottomChild;

  const TopLogPanel({
    super.key,
    required this.controller,
    required this.title,
    this.enableCopy,
    this.enableAutoScroll,
    this.enableClear,
    this.enableCollapse,
    this.bottomChild,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部按钮控制面板
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
              const Spacer(),
              if (enableAutoScroll ?? true) _autoScrollButton(),
              if (enableCopy ?? true) _copyButton(),
              if (enableClear ?? true) _deleteButton(),
              if (enableCollapse ?? true) _collapseButton(),
            ],
          ).paddingAll(8).constrained(height: 48),
          // 底部
          if (bottomChild != null) ...[
            const Divider(height: 1),
            bottomChild!,
          ],
        ],
      ),
    );
  }

  Widget _copyButton() {
    return IconButton(
      icon: const Icon(Icons.content_copy_rounded, size: 18),
      onPressed: () => controller.copyLogs(),
    );
  }

  Widget _autoScrollButton() {
    return Obx(() => IconButton(
          icon: Icon(
            controller.autoScroll.value ? Icons.flash_on : Icons.flash_off,
            size: 20,
          ),
          onPressed: controller.toggleAutoScroll,
        ));
  }

  Widget _deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outlined, size: 20),
      onPressed: () => controller.clearLog(),
    );
  }

  Widget _collapseButton() {
    return Obx(() => IconButton(
          icon: Icon(
            controller.collapseLog.value
                ? Icons.expand_more
                : Icons.expand_less,
            size: 20,
          ),
          onPressed: () => controller.toggleCollapse(),
        ));
  }
}

/// 日志内容区
class LogContent extends StatelessWidget {
  final LogMixin controller;

  const LogContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Get.theme.cardColor,
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              controller.handleUserScroll();
            }
            return false;
          },
          child: Obx(() => ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.logs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: EasyRichText(
                    controller.logs[index], // 逐行处理日志
                    patternList: _buildPatterns(),
                    selectable: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    defaultStyle: _selectStyle(context),
                  ),
                ),
              ).paddingAll(10)),
        ),
      ),
    ).constrained(width: double.infinity, height: double.infinity);
  }

  List<EasyRichTextPattern> _buildPatterns() {
    return [
      const EasyRichTextPattern(
        targetString: 'INFO',
        style: TextStyle(
          color: Color.fromARGB(255, 55, 109, 136),
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        suffixInlineSpan: TextSpan(
          style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
          text: '      ',
        ),
      ),
      const EasyRichTextPattern(
        targetString: 'WARNING',
        style: TextStyle(
          color: Colors.yellow,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
      const EasyRichTextPattern(
        targetString: 'ERROR',
        style: TextStyle(
          color: Colors.red,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        suffixInlineSpan: TextSpan(
          style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
          text: '    ',
        ),
      ),
      const EasyRichTextPattern(
        targetString: 'CRITICAL',
        style: TextStyle(
          color: Colors.red,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        suffixInlineSpan: TextSpan(text: '   '),
      ),
      const EasyRichTextPattern(
        targetString: r'(\d{2}:\d{2}:\d{2}\.\d{3})',
        style: TextStyle(
          color: Colors.cyan,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
      const EasyRichTextPattern(
        targetString: r'[\{\[\(\)\]\}]',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const EasyRichTextPattern(
          targetString: 'True', style: TextStyle(color: Colors.lightGreen)),
      const EasyRichTextPattern(
          targetString: 'False', style: TextStyle(color: Colors.red)),
      const EasyRichTextPattern(
          targetString: 'None', style: TextStyle(color: Colors.purple)),
      const EasyRichTextPattern(
        targetString: r'(══*══)|(──*──)',
        style: TextStyle(color: Colors.lightGreen),
      )
    ];
  }

  TextStyle _selectStyle(BuildContext context) {
    return context.mediaQuery.orientation == Orientation.portrait
        ? Get.textTheme.bodySmall!
        : Get.textTheme.titleSmall!;
  }
}
