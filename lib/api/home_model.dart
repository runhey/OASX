import 'package:flutter_nb_net/flutter_net.dart';
import 'dart:convert';

class ReadmeGithubModel extends BaseNetModel {
  @override
  ReadmeGithubModel fromJson(Map<String, dynamic> json) {
    return ReadmeGithubModel.fromJson(json);
  }

  ReadmeGithubModel({
    this.content,
  });
  ReadmeGithubModel.fromJson(dynamic json) {
    content = utf8.decode(base64.decode(json['content'].replaceAll('\n', '')));
    content = content!.replaceAll('''<div>
    <img alt="python" src="https://img.shields.io/badge/python-3.10-%233776AB?logo=python">
</div>''', '');
    content = content!.replaceAll('''<div>
    <img alt="platform" src="https://img.shields.io/badge/platform-Windows-blueviolet">
</div>''', '');
    content = content!.replaceAll('''
<div>
    <img alt="license" src="https://img.shields.io/github/license/runhey/OnmyojiAutoScript">
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/runhey/OnmyojiAutoScript">
    <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/runhey/OnmyojiAutoScript/total">
    <img alt="stars" src="https://img.shields.io/github/stars/runhey/OnmyojiAutoScript?style=social">
</div>''', '');
    content = content!.replaceAll('<br>', '');
    content = content!.replaceAll('</div>', '');
    content = content!.replaceAll('<div align="center">', '');
  }

  String? content;
}
