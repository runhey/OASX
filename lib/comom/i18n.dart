import 'package:get/get.dart';

import 'package:oasx/comom/i18n_content.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          I18nContent.log_out: '退出登录',
          I18nContent.zh_cn: '简体中文',
          I18nContent.en_us: 'English',
          I18nContent.change_theme: '切换主题',
          I18nContent.change_language: '切换语言',
          I18nContent.project_statement: '开源软件',
        },
        'en_US': {
          I18nContent.log_out: 'Logout',
          I18nContent.zh_cn: '简体中文',
          I18nContent.en_us: 'English',
          I18nContent.change_theme: 'Change Theme',
          I18nContent.change_language: 'Change Language',
          I18nContent.project_statement: 'Open Source Software',
        }
      };
}
