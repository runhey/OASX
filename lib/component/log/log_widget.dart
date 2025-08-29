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

  const LogWidget(
      {super.key,
      required this.controller,
      required this.title,
      this.enableCopy,
      this.enableAutoScroll,
      this.enableClear,
      this.enableCollapse});

  @override
  State<StatefulWidget> createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        logTopPanel(),
        Obx(() => widget.controller.collapseLog.value
            ? const SizedBox.shrink()
            : logContent()),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.restoreScrollOffset();
  }

  @override
  void deactivate() {
    widget.controller.saveScrollOffset();
    super.deactivate();
  }

  Widget logTopPanel() {
    return Card(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
            const Spacer(),
            if (widget.enableAutoScroll ?? true) autoScrollButton(),
            if (widget.enableCopy ?? true) copyButton(),
            if (widget.enableClear ?? true) deleteButton(),
            if (widget.enableCollapse ?? true) collapseButton(),
          ],
        ).paddingAll(8).constrained(height: 48));
  }

  Widget copyButton() {
    return IconButton(
      icon: const Icon(Icons.content_copy_rounded, size: 18),
      onPressed: () => widget.controller.copyLogs(),
    );
  }

  Widget autoScrollButton() {
    return Obx(() => IconButton(
          icon: Icon(
            widget.controller.autoScroll.value
                ? Icons.flash_on
                : Icons.flash_off,
            // : Icons.keyboard_double_arrow_down_rounded,
            size: 20,
          ),
          onPressed: widget.controller.toggleAutoScroll,
        ));
  }

  Widget deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outlined, size: 20),
      onPressed: () => widget.controller.clearLog(),
    );
  }

  Widget collapseButton() {
    return Obx(() => IconButton(
          icon: Icon(
            widget.controller.collapseLog.value
                ? Icons.expand_more
                : Icons.expand_less,
            size: 20,
          ),
          onPressed: () => widget.controller.toggleCollapse(),
        ));
  }

  Widget logContent() {
    return Expanded(
      child: Card(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Get.theme.cardColor,
                  ),
                  child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          widget.controller.handleUserScroll();
                        }
                        return false;
                      },
                      child: Obx(() => ListView.builder(
                            controller: widget.controller.scrollController,
                            itemCount: widget.controller.logs.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: EasyRichText(
                                widget.controller.logs[index], // 逐行处理日志
                                patternList: _buildPatterns(),
                                selectable: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                defaultStyle: _selectStyle(context),
                              ),
                            ),
                          ).paddingAll(10)))))
          .constrained(width: double.infinity, height: double.infinity),
    );
  }

  List<EasyRichTextPattern> _buildPatterns() {
    return [
      // INFO
      const EasyRichTextPattern(
        targetString: 'INFO',
        style: TextStyle(
          color: Color.fromARGB(255, 55, 109, 136),
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        suffixInlineSpan: TextSpan(
            style: TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            text: '      '),
      ),
      // WARNING
      const EasyRichTextPattern(
        targetString: 'WARNING',
        style: TextStyle(
          color: Colors.yellow,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        // suffixInlineSpan: const TextSpan(text: ''),
      ),
      // ERROR
      const EasyRichTextPattern(
        targetString: 'ERROR',
        style: TextStyle(
          color: Colors.red,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        suffixInlineSpan: TextSpan(
            style: TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            text: '    '),
      ),
      // CRITICAL
      const EasyRichTextPattern(
        targetString: 'CRITICAL',
        style: TextStyle(
          color: Colors.red,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        suffixInlineSpan: TextSpan(text: '   '),
      ),
      // 时间的
      const EasyRichTextPattern(
        targetString: r'(\d{2}:\d{2}:\d{2}\.\d{3})',
        style: TextStyle(
          color: Colors.cyan,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
      // 粗体
      const EasyRichTextPattern(
        targetString: r'[\{\[\(\)\]\}]',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // True
      const EasyRichTextPattern(
          targetString: 'True', style: TextStyle(color: Colors.lightGreen)),
      // False
      const EasyRichTextPattern(
          targetString: 'False', style: TextStyle(color: Colors.red)),
      // None
      const EasyRichTextPattern(
          targetString: 'None', style: TextStyle(color: Colors.purple)),
      // 路径Path
      // EasyRichTextPattern(
      //     targetString: r'([A-Za-z]\:)|.)?\B([\/\\][\w\.\-\_\+]+)*[\/\\]',
      //     style: const TextStyle(
      //         color: Colors.purple, fontStyle: FontStyle.italic)),
      // 分割线
      const EasyRichTextPattern(
        targetString: r'(══*══)|(──*──)',
        style: TextStyle(color: Colors.lightGreen),
      )
    ];
  }

  // 文字样式选择方法
  TextStyle _selectStyle(BuildContext context) {
    return context.mediaQuery.orientation == Orientation.portrait
        ? Get.textTheme.bodySmall!
        : Get.textTheme.titleSmall!;
  }
}
