import 'dart:convert';

class Integer {
  final String title;
  int value;
  final String description;
  final int integerDefault;
  final String type;
  final int? minimum;
  final int? maximum;

  Integer({
    required this.title,
    required this.value,
    required this.description,
    required this.integerDefault,
    required this.type,
    this.minimum,
    this.maximum,
  });

  factory Integer.fromRawJson(String str) => Integer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Integer.fromJson(Map<String, dynamic> json) => Integer(
        title: json["title"],
        value: json["value"],
        description: json["description"],
        integerDefault: json["default"],
        type: json["type"],
        minimum: json["minimum"],
        maximum: json["maximum"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "description": description,
        "default": integerDefault,
        "type": type,
        "minimum": minimum,
        "maximum": maximum,
      };
}
