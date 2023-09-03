import 'dart:convert';

class PurpleString {
  final String title;
  final String value;
  final String description;
  final String stringDefault;
  final String type;

  PurpleString({
    required this.title,
    required this.value,
    required this.description,
    required this.stringDefault,
    required this.type,
  });

  factory PurpleString.fromRawJson(String str) =>
      PurpleString.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleString.fromJson(Map<String, dynamic> json) => PurpleString(
        title: json["title"],
        value: json["value"],
        description: json["description"],
        stringDefault: json["default"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "description": description,
        "default": stringDefault,
        "type": type,
      };
}
