part of args;

final dateYears = <String>['2023', '2024', '2025', '2026'];
final dateMonths = List.generate(
        12, (index) => (index + 1) < 10 ? '0${index + 1}' : '${index + 1}')
    .toList();
final dateDaysInMonth = List.generate(daysInMonth(),
    (index) => (index + 1) < 10 ? '0${index + 1}' : '${index + 1}').toList();
final dateDaysInWeek =
    List.generate(7, (index) => index < 10 ? '0$index' : '$index').toList();
final dateHours =
    List.generate(24, (index) => index < 10 ? '0$index' : '$index').toList();
final dateMinutes =
    List.generate(60, (index) => index < 10 ? '0$index' : '$index').toList();
final dateSeconds =
    List.generate(60, (index) => index < 10 ? '0$index' : '$index').toList();

final dateTimeData = [
  dateYears,
  dateMonths,
  dateDaysInMonth,
  dateHours,
  dateMinutes,
  dateSeconds,
];
final dateTimeDelta = [
  dateDaysInWeek,
  dateHours,
  dateMinutes,
  dateSeconds,
];
final dateTime = [
  dateHours,
  dateMinutes,
  dateSeconds,
];

int daysInMonth() {
  DateTime now = DateTime.now();
  int year = now.year;
  int month = now.month;
  DateTime lastDayOfMonth =
      DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
  return lastDayOfMonth.day;
}

// -------------------------------------------------------------------------Base

class DateTimePickerBase extends StatefulWidget {
  String value = '';
  void Function(String value) onChange = (value) {};

  DateTimePickerBase({super.key, required this.value, required this.onChange});

  @override
  State<StatefulWidget> createState() => DateTimePickerBaseState();
}

class DateTimePickerBaseState extends State<DateTimePickerBase> {
  // 占位

  // 鼠标是否在这个区域内
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) {
          setState(() {
            _isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            _isHover = false;
          });
        },
        child: GestureDetector(
          child: Text(widget.value,
              style: _isHover
                  ? TextStyle(color: Theme.of(context).primaryColor)
                  : const TextStyle()),
          onTap: () {
            showPicker(context, widget.value);
          },
        ));
  }

  // 重写
  void showPicker(context, dynamic value) {
    Pickers.showMultiPicker(
      context,
      data: dateTimeData,
      suffix: [
        I18n.year.tr,
        I18n.month.tr,
        I18n.day.tr,
        I18n.hour.tr,
        I18n.minute.tr,
        I18n.seconds.tr
      ],
    );
  }
}

// ---------------------------------------------------------------------DateTime
class DateTimePicker extends DateTimePickerBase {
  DateTimePicker({super.key, required super.value, required super.onChange});

  @override
  State<StatefulWidget> createState() => DateTimePickerState();
}

class DateTimePickerState extends DateTimePickerBaseState {
  void showPicker(context, dynamic value) {
    Pickers.showMultiPicker(
      context,
      pickerStyle: Theme.of(context).brightness == Brightness.light
          ? DefaultPickerStyle()
          : DefaultPickerStyle.dark(),
      data: dateTimeData,
      selectData: prePrecess(value),
      onConfirm: onConfirm,
      suffix: [
        I18n.year.tr,
        I18n.month.tr,
        I18n.day.tr,
        I18n.hour.tr,
        I18n.minute.tr,
        I18n.seconds.tr
      ],
    );
  }

  dynamic onConfirm(List<dynamic> p, List<int> position) {
    print('longer >>> 返回数据下标：${position.join(',')}');
    print('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
    String year = dateTimeData[0][position[0]];
    String month = dateTimeData[1][position[1]];
    String day = dateTimeData[2][position[2]];
    String hour = dateTimeData[3][position[3]];
    String minute = dateTimeData[4][position[4]];
    String seconds = dateTimeData[5][position[5]];
    widget.onChange('$year-$month-$day $hour:$minute:$seconds');
  }

  // 数据的预处理
  List prePrecess(dynamic value) {
    List result = [0, 0, 0, 0, 0, 0];
    // 如果是字符串, 那就分离出2023-10-02T11:11:11
    if (value is String) {
      result = value.split(RegExp(r'\D+'));
    }
    return result;
  }
}
