// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

import 'package:oasx/comom/i18n_content.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    Map<String, String> en_us = {};
    Map<String, String> zh_CN = {};
    zh_CN.addAll(_cn_ui);
    zh_CN.addAll(_cn_menu);
    zh_CN.addAll(_cn_script);
    zh_CN.addAll(_cn_restart);
    zh_CN.addAll(_cn_global_game);
    en_us.addAll(_us_menu);
    return {
      'en_us': en_us,
      'zh_CN': zh_CN,
    };
  }

  Map<String, String> get _cn_ui => {
        I18n.log_out: '退出登录',
        I18n.zh_cn: '简体中文',
        I18n.en_us: 'English',
        I18n.change_theme: '切换主题',
        I18n.change_language: '切换语言',
        I18n.project_statement: '开源软件',
        I18n.year: '年',
        I18n.month: '月',
        I18n.day: '日',
        I18n.week: '星期',
        I18n.hour: '时',
        I18n.minute: '分',
        I18n.seconds: '秒',
        I18n.network_error: '网络错误',
        I18n.no_data: '暂无数据',
        I18n.network_error_message: '请检查网络连接',
        I18n.network_error_code: '错误代码',
        I18n.network_connect_timeout: '连接超时',
        I18n.scheduler: '调度器',
        I18n.running: '运行中',
        I18n.pending: '队列中',
        I18n.waiting: '等待中',
        I18n.task_setting: '设置',
        I18n.log: '日志',
        I18n.clear_log: '清空日志',
        I18n.login: '登录',
        I18n.setting: '设置',
        I18n.notify_test: '推送测试',
        I18n.notify_test_config: '推送配置',
        I18n.notify_test_help: '请翻阅文档[消息推送]进行填写相关配置',
        I18n.notify_test_title: '发送主题',
        I18n.notify_test_content: '发送内容',
        I18n.notify_test_send: '点击测试',
        I18n.notify_test_success: '推送成功',
        I18n.notify_test_failed: '推送失败',
        I18n.current_version: '当前版本',
        I18n.latest_version: '最新版本',
        I18n.find_new_version: '发现新版本',
        I18n.kill_oas_server: '结束OAS服务',
        I18n.are_you_sure_kill: '真的要关闭脚本服务吗',
        I18n.kill_server_success: '关闭服务成功',
        I18n.kill_server_failure: '关闭服务失败',
        I18n.find_oas_new_version: '发现OAS新版本',
        I18n.oas_latest_version: 'OAS已是最新版本',
        I18n.current_branch: '当前分支',
        I18n.detailed_submission_history: '详细提交历史',
        I18n.author: '作者',
        I18n.submit_time: '提交时间',
        I18n.submit_info: '提交信息',
        I18n.local_repo: '本地仓库',
        I18n.remote_repo: '远程仓库',
        I18n.root_path_server: 'OAS根目录',
        I18n.select_root_path_server: '选择文件夹',
        I18n.root_path_server_help:
            'OASX跟OAS是两个不同的东西, 不要搞混，不要放在同一个目录下, 不要有空格的, 不要有中文的, 也不要路径过长的',
        I18n.root_path_correct: '正确识别为OAS的根目录',
        I18n.root_path_incorrect: '无法识别的根目录，你可能没有正确安装OAS',
        I18n.install_oas_now: '现在安装OAS',
        I18n.install_oas_success: '安装OAS成功',
        I18n.install_oas_failure: '安装OAS失败',
        I18n.install_oas_from_github: '从GitHub安装OAS',
        I18n.install_oas_help: '这将会从Github上下载并解压，请保持网络稳定，同时将会清空该目录',
      };

  Map<String, String> get _cn_menu => {
        I18n.overview: '总览',
        I18n.home: '主页',
        I18n.about: '关于',
        I18n.updater: '更新器',
        I18n.tool: '工具',
        I18n.task_list: '任务列表',
        I18n.script: '脚本',
        I18n.restart: '重启',
        I18n.global_game: '全局配置',
        I18n.soul_zones: '御魂副本',
        I18n.orochi: '八岐大蛇',
        I18n.sougenbi: '业原火',
        I18n.fallen_sun: '日轮之城',
        I18n.eternity_sea: '永生之海',
        I18n.daily_task: '日常任务',
        I18n.daily_trifles: '每日琐事',
        I18n.area_boss: '地狱鬼王',
        I18n.gold_youkai: '金币妖怪',
        I18n.experience_youkai: '经验妖怪',
        I18n.nian: '年兽',
        I18n.talisman_pass: '花合战',
        I18n.demon_encounter: '封魔之时',
        I18n.pets: '小猫咪',
        I18n.souls_tidy: '御魂整理',
        I18n.delegation: '式神委派',
        I18n.wanted_quests: '悬赏封印',
        I18n.tako: '石距',
        I18n.liver_emperor_exclusive: '肝帝专属',
        I18n.guild: '阴阳寮',
        I18n.weekly_task: '每周任务',
        I18n.activity_task: '限时活动',
        I18n.tools: '工具',
        I18n.bondling_fairyland: '契灵之境',
        I18n.evo_zone: '觉醒副本',
        I18n.goryou_realm: '御灵之境',
        I18n.exploration: '探索',
        I18n.kekkaiUtilize: '结界蹭卡',
        I18n.kekkaiActivation: '结界挂卡',
        I18n.realm_raid: '个人突破',
        I18n.ryou_toppa: '寮突破',
        I18n.collective_missions: '集体任务',
        I18n.hunt: '狩猎战',
        I18n.true_orochi: '真八岐大蛇',
        I18n.rich_man: '大富翁',
        I18n.secret: '秘闻之境',
        I18n.weekly_trifles: '每周琐事',
        I18n.mystery_shop: '神秘商店',
        I18n.duel: '斗鸡',
        I18n.activity_shikigami: '当期爬塔',
      };
  Map<String, String> get _us_menu => {
        I18n.log_out: 'Logout',
        I18n.zh_cn: '简体中文',
        I18n.en_us: 'English',
        I18n.change_theme: 'Change Theme',
        I18n.change_language: 'Change Language',
        I18n.project_statement: 'Open Source Software',
        // 菜单项相关
        I18n.overview: 'Overview',
        I18n.home: 'Home',
        I18n.about: 'About',
        I18n.updater: 'Updater',
        I18n.tool: 'Tool',
        I18n.task_list: 'Task List',
        I18n.script: 'Script',
        I18n.restart: 'Restart',
        I18n.global_game: 'GlobalGame',
        I18n.soul_zones: 'Soul Zones',
        I18n.orochi: 'Orochi',
        I18n.sougenbi: 'Sougenbi',
        I18n.fallen_sun: 'FallenSun',
        I18n.eternity_sea: 'EternitySea',
        I18n.daily_task: 'Daily Task',
        I18n.daily_trifles: 'DailyTrifles',
        I18n.area_boss: 'AreaBoss',
        I18n.gold_youkai: 'GoldYoukai',
        I18n.experience_youkai: 'ExperienceYoukai',
        I18n.nian: 'Nian',
        I18n.talisman_pass: 'TalismanPass',
        I18n.demon_encounter: 'DemonEncounter',
        I18n.pets: 'Pets',
        I18n.souls_tidy: 'SoulsTidy',
        I18n.delegation: 'Delegation',
        I18n.wanted_quests: 'WantedQuests',
        I18n.tako: 'Tako',
        I18n.liver_emperor_exclusive: 'LiverEmperorExclusive',
        I18n.guild: 'Guild',
        I18n.weekly_task: 'Weekly Task',
        I18n.activity_task: 'Activity Task',
        I18n.tools: 'Tools',
        I18n.bondling_fairyland: 'BondlingFairyland',
        I18n.evo_zone: 'EvoZone',
        I18n.goryou_realm: 'GoryouRealm',
        I18n.exploration: 'Exploration',
        I18n.kekkaiUtilize: 'KekkaiUtilize',
        I18n.kekkaiActivation: 'KekkaiActivation',
        I18n.realm_raid: 'RealmRaid',
        I18n.ryou_toppa: 'RyouToppa',
        I18n.collective_missions: 'CollectiveMissions',
        I18n.hunt: 'Hunt',
        I18n.true_orochi: 'TrueOrochi',
        I18n.rich_man: 'RichMan',
        I18n.secret: 'Secret',
        I18n.weekly_trifles: 'WeeklyTrifles',
        I18n.mystery_shop: 'MysteryShop',
        I18n.duel: 'Duel',
        I18n.activity_shikigami: 'ActivityShikigami',
      };

  Map<String, String> get _cn_script => {
        I18n.device: '模拟器设置',
        I18n.error: '出错设置',
        I18n.optimization: '优化设置',
        I18n.serial: '模拟器 Serial',
        I18n.serial_help: '''常见的模拟器 Serial 可以查询下方列表
填 "auto" 自动检测模拟器，多个模拟器正在运行或使用不支持自动检测的模拟器时无法使用 "auto"，必须手动填写

模拟器默认 Serial:
[MuMu模拟器12]: 127.0.0.1:16384 
[MuMu模拟器]: 127.0.0.1:7555 
[雷电模拟器](全系列通用): emulator-5554 或 127.0.0.1:5555

如果没有提及的那可能是还没有测试或者不推荐使用，可以自行尝试
如果你使用了模拟器的多开功能，它们的 Serial 将不是默认的，可以在 console.bat 中执行 `adb devices` 查询，或根据模拟器官方的教程填写''',
        I18n.handle: '句柄 Handle',
        I18n.handle_help:
            '''填 "auto" 自动检测模拟器，多个模拟器正在运行或使用不支持自动检测的模拟器时无法使用 "auto"，必须手动填写
输入为句柄标题或者是句柄号，每次启动模拟器时句柄号会变化。清空表示不使用window的操作方式。

句柄标题 Handle:
[MuMu模拟器12]: "MuMu模拟器12"
[MuMu模拟器]: "MuMu模拟器" 
[雷电模拟器](全系列通用): "雷电模拟器"

句柄号 Handle:
某些模拟器多开时具有相同的句柄标题（说的就是MuMu），此时需要手动获取模拟器的句柄号手动设置。
获取工具请查阅文档：[模拟器支持]''',
        I18n.package_name: '游戏客户端',
        I18n.package_name_help: '模拟器上装有多个游戏客户端时，需要手动选择服务器',
        I18n.screenshot_method: '模拟器截屏方案',
        I18n.screenshot_method_help:
            '''使用自动选择时，将执行一次性能测试并自动更改为最快的截图方案。一般情况下的速度: 
window_background >>> DroidCast_raw >  ADB_nc >> DroidCast > uiautomator2 ~= ADB
使用window_background来截图是10ms左右，对比DroidCast_raw是100ms左右（仅限作者的电脑）。但是window_background有一个致命的缺点是模拟器不可以最小化，望周知''',
        I18n.control_method: '模拟器控制方案',
        I18n.control_method_help:
            '''速度: window_message ~= minitouch > Hermit >>> uiautomator2 ~= ADB
控制方式是模拟人类的速度，也不是越快越好 使用(window_message)会偶尔出现失效的情况''',
        I18n.adb_restart: '在检测不到设备的时候尝试重启adb',
        I18n.adb_restart_help: '',
        I18n.handle_error: '启用异常处理',
        I18n.handle_error_help: '处理部分异常，运行出错时撤退',
        I18n.save_error: '出错时，保存 Log 和截图',
        I18n.screenshot_length: '出错时，保留最后 X 张截图',
        I18n.notify_enable: '启用消息推送',
        I18n.notify_config: '消息推送配置',
        I18n.notify_config_help: '输入为yaml格式，":"冒号后有一个空格，具体请翻阅文档[消息推送]',
        I18n.screenshot_interval: '放慢截图速度至 X 秒一张',
        I18n.screenshot_interval_help:
            '执行两次截图之间的最小间隔，限制在 0.1 ~ 0.3，对于高配置电脑能降低 CPU 占用',
        I18n.combat_screenshot_interval: '战斗中放慢截图速度至 X 秒一张',
        I18n.combat_screenshot_interval_help:
            '执行两次截图之间的最小间隔，限制在 0.1 ~ 1.0，能降低战斗时的 CPU 占用',
        I18n.task_hoarding_duration: '囤积任务 X 分钟',
        I18n.task_hoarding_duration_help:
            '能在收菜期间降低操作游戏的频率,任务触发后，等待 X 分钟，再一次性执行囤积的任务',
        I18n.when_task_queue_empty: '当任务队列清空后',
        I18n.when_task_queue_empty_help: '无任务时关闭游戏，能在收菜期间降低 CPU 占用',
        I18n.schedule_rule: '选择任务调度规则',
        I18n.schedule_rule_help: '''这里所指的调度的对象是指Pending中的，Waiting中的任务不属于。
基于过滤器(Filter)的调度：默认的选项，任务的执行顺序会根据开发时所确定的顺序来调度，一般是最优解
基于先来后到(FIFO)的调度：是会按照下次执行时间进行排序，靠前的先执行
基于优先级(Priority)的调度：高优先级先于低优先级执行，同优先级按照先来后到顺序'''
      };
  Map<String, String> get _cn_restart => {
        I18n.havrvest_config: '收菜配置',
        I18n.enable: '启用该功能',
        I18n.enable_help: '将这个任务加入调度器',
        I18n.next_run: '下一次运行时间',
        I18n.next_run_help: '会根据下面的间隔时间自动计算时间',
        I18n.priority: '任务优先级',
        I18n.priority_help:
            '如果设置调度规则为基于优先级，则该选项有效，默认为5，数字越低优先级越高，可取[1~15],如果同优先级,则按照先来后到规则进行调度',
        I18n.success_interval: '执行任务成功后设定经过 X 时间后执行',
        I18n.success_interval_help: '',
        I18n.failure_interval: '执行任务失败后设定经过 X 时间后执行',
        I18n.failure_interval_help: '',
        I18n.server_update: '强制设定服务执行时间',
        I18n.server_update_help:
            '如果设定不是默认的 "09:00:00",该任务每次执行完毕后会强制设定下次运行时间为第二天的设定值',
        I18n.harvest_enable_help: '这个一个部分是为了在登录游戏时，自动点击赠送的奖励，是必选项',
        I18n.enable_jade: '永久勾玉卡',
        I18n.enable_sign: '每日签到',
        I18n.enable_sign_999: '签到999天后的签到福袋',
        I18n.enable_mail: '邮件',
        I18n.enable_soul: '御魂或者觉醒加成',
        I18n.enable_ap: '体力',
      };
  Map<String, String> get _cn_global_game => {
        I18n.emergency: '突发检测',
        I18n.team_flow: 'team_flow',
        I18n.friend_invitation: '当出现协作邀请时',
        I18n.friend_invitation_help: '默认全部接受',
        I18n.invitation_detect_interval: '检测间隔',
        I18n.invitation_detect_interval_help: '默认每隔10秒检测一次是否有协作',
        I18n.when_network_abnormal: '当网络异常时',
        I18n.when_network_abnormal_help: '默认会先等待10S',
        I18n.when_network_error: '当网络出错需要重新连接服务器时',
        I18n.when_network_error_help: '重启游戏',
        I18n.home_client_clear: '启用庭院客户端清空缓存',
        I18n.home_client_clear_help: '有时会出现进入庭院要求清理缓存',
        I18n.enable_help: '将这个任务加入调度器',
        I18n.broker: 'broker',
        I18n.broker_help: '',
        I18n.port: 'port',
        I18n.port_help: '',
        I18n.transport: 'transport',
        I18n.transport_help: '',
        I18n.ca: 'ca',
        I18n.ca_help: '',
        I18n.username: 'username',
        I18n.username_help: '',
        I18n.password: 'password',
        I18n.password_help: '',
      };
}
