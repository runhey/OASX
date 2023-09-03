import 'dart:convert';

class Boolean {
  final String title;
  final bool value;
  final String description;
  final bool booleanDefault;
  final String type;

  Boolean({
    required this.title,
    required this.value,
    required this.description,
    required this.booleanDefault,
    required this.type,
  });

  factory Boolean.fromRawJson(String str) => Boolean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Boolean.fromJson(Map<String, dynamic> json) => Boolean(
        title: json["title"],
        value: json["value"],
        description: json["description"],
        booleanDefault: json["default"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "description": description,
        "default": booleanDefault,
        "type": type,
      };
}
