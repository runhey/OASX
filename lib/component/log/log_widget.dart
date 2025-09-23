import 'dart:math';

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
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController ??= ScrollController(
        initialScrollOffset: widget.controller.savedScrollOffsetVal);
    // 位置调整
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.controller.autoScroll.value) {
        // 自动滚动模式：强制滚动到底部
        _scrollLogs(force: true, scrollOffset: -1);
      } else if (widget.controller.savedScrollOffsetVal > 0) {
        // 非自动滚动模式：恢复到保存的位置
        _scrollLogs(
            force: true, scrollOffset: widget.controller.savedScrollOffsetVal);
      }
    });
    widget.controller.scrollLogs = _scrollLogs;
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
            : LogContent(
                controller: widget.controller,
                scrollController: _scrollController!,
                onUserScroll: _handleUserScroll,
              ).expanded()),
      ],
    );
  }

  @override
  void deactivate() {
    if (_scrollController != null && _scrollController!.hasClients) {
      widget.controller.saveScrollOffset(_scrollController!.offset);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_scrollController != null && _scrollController!.hasClients) {
      widget.controller.saveScrollOffset(_scrollController!.offset);
    }
    widget.controller.scrollLogs = null;
    _scrollController?.dispose();
    _scrollController = null;
    super.dispose();
  }

  void _scrollLogs({isJump = false, force = false, scrollOffset = -1}) {
    if (_scrollController == null || !_scrollController!.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController == null || !_scrollController!.hasClients) return;
      // 强制滚动或自动滚动才允许滚动
      if (!force && !widget.controller.autoScroll.value) return;
      final double targetPos = scrollOffset == -1
          ? _scrollController!.position.maxScrollExtent
          : scrollOffset;
      if (isJump) {
        _scrollController!.jumpTo(targetPos);
        return;
      }
      final double currentPos = _scrollController!.offset;
      final double distance = (targetPos - currentPos).abs();
      // 使用非线性函数计算动画时间
      // 1000px 约 300ms,10000px 约 1000ms
      int animateMs = (sqrt(distance) * 10).toInt();
      const int minAnimateMs = 100; // 最快速度
      const int maxAnimateMs = 1000; // 最慢速度
      // 限制范围
      animateMs = animateMs.clamp(minAnimateMs, maxAnimateMs);
      // 滚动
      _scrollController!
          .animateTo(targetPos,
              duration: Duration(milliseconds: animateMs),
              curve: Curves.easeOut)
          .whenComplete(() {
        final latestExtent = _scrollController!.position.maxScrollExtent;
        // 矫正滚动位置(最底部或自动滚动且最新位置不同,跳转到新的最底部)
        if ((scrollOffset == -1 || widget.controller.autoScroll.value) &&
            latestExtent > targetPos) {
          _scrollController!.jumpTo(latestExtent);
        }
      });
    });
  }

  void _handleUserScroll() {
    if (_scrollController == null || !_scrollController!.hasClients) return;
    final maxExtent = _scrollController!.position.maxScrollExtent;
    final currentOffset = _scrollController!.offset;

    // 判断是否在底部（容差80像素）
    final isAtBottom = currentOffset >= (maxExtent - 80);

    // 更新自动滚动状态
    if (isAtBottom && !widget.controller.autoScroll.value) {
      // 用户滚动到底部，开启自动滚动
      widget.controller.autoScroll.value = true;
    } else if (!isAtBottom && widget.controller.autoScroll.value) {
      // 用户向上滚动超过80像素，关闭自动滚动
      widget.controller.autoScroll.value = false;
    }
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
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium),
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
  final ScrollController scrollController;
  final Function() onUserScroll;

  const LogContent({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.onUserScroll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          onUserScroll();
          return false;
        },
        child: Obx(() => ListView.builder(
              controller: scrollController,
              itemCount: controller.logs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: EasyRichText(
                  controller.logs[index],
                  patternList: _buildPatterns(),
                  selectable: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  defaultStyle: _selectStyle(context),
                ),
              ),
            ).paddingAll(10)),
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
        ? Theme.of(context).textTheme.bodySmall!
        : Theme.of(context).textTheme.titleSmall!;
  }
}
