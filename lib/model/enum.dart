import 'dart:convert';

class Enum {
  final String title;
  final String value;
  final String description;
  final List<String> enumEnum;
  final String type;

  Enum({
    required this.title,
    required this.value,
    required this.description,
    required this.enumEnum,
    required this.type,
  });

  factory Enum.fromRawJson(String str) => Enum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Enum.fromJson(Map<String, dynamic> json) => Enum(
        title: json["title"],
        value: json["value"],
        description: json["description"],
        enumEnum: List<String>.from(json["enum"].map((x) => x)),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "description": description,
        "enum": List<dynamic>.from(enumEnum.map((x) => x)),
        "type": type,
      };
}
