import 'dart:convert';

class Number {
  final String title;
  final double value;
  final String description;
  final double numberDefault;
  final String type;
  final double? minimum;
  final double? maximum;

  Number({
    required this.title,
    required this.value,
    required this.description,
    required this.numberDefault,
    required this.type,
    this.minimum,
    this.maximum,
  });

  factory Number.fromRawJson(String str) => Number.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Number.fromJson(Map<String, dynamic> json) => Number(
        title: json["title"],
        value: json["value"]?.toDouble(),
        description: json["description"],
        numberDefault: json["default"]?.toDouble(),
        type: json["type"],
        minimum: json["minimum"]?.toDouble(),
        maximum: json["maximum"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "description": description,
        "default": numberDefault,
        "type": type,
        "minimum": minimum,
        "maximum": maximum,
      };
}
