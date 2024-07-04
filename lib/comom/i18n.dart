// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

import 'package:oasx/comom/i18n_content.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    Map<String, String> en_us = {};
    en_us.addAll(_us_menu);
    Map<String, String> zh_CN = {};
    zh_CN.addAll(_cn_ui);
    zh_CN.addAll(_cn_menu);
    zh_CN.addAll(_cn_script);
    zh_CN.addAll(_cn_restart);
    zh_CN.addAll(_cn_global_game);
    zh_CN.addAll(_cn_raid_config);
    zh_CN.addAll(_cn_invite_config);
    zh_CN.addAll(_cn_general_battle_config);
    zh_CN.addAll(_cn_switch_soul);
    zh_CN.addAll(_cn_orochi_config);
    zh_CN.addAll(_cn_sougenbi_config);
    zh_CN.addAll(_cn_fallen_sun_config);
    zh_CN.addAll(_cn_eternity_sea_config);
    zh_CN.addAll(_cn_dragon_spine_config);
    zh_CN.addAll(_cn_area_boss_config);
    zh_CN.addAll(_cn_gold_youkai_config);
    zh_CN.addAll(_cn_nian_config);
    zh_CN.addAll(_cn_talisman_config);
    zh_CN.addAll(_cn_pets_config);
    zh_CN.addAll(_cn_simple_tidy_config);
    zh_CN.addAll(_cn_delegation_config);
    zh_CN.addAll(_cn_wanted_quests_config);
    zh_CN.addAll(_cn_tako_config);
    zh_CN.addAll(_cn_bondling_config);
    zh_CN.addAll(_cn_evo_zone_config);
    zh_CN.addAll(_cn_goryou_config);
    zh_CN.addAll(_cn_exploration_config);
    zh_CN.addAll(_cn_utilize_config);
    zh_CN.addAll(_cn_activation_config);
    zh_CN.addAll(_cn_realm_raid_config);
    zh_CN.addAll(_cn_missions_config);
    zh_CN.addAll(_cn_hunt_config);
    zh_CN.addAll(_cn_true_orochi_config);
    zh_CN.addAll(_cn_rich_man_config);
    zh_CN.addAll(_cn_secret_config);
    zh_CN.addAll(_cn_trifles_config);
    zh_CN.addAll(_cn_shop_config);
    zh_CN.addAll(_cn_duel_config);
    zh_CN.addAll(_cn_general_climb_config);
    zh_CN.addAll(_cn_meta_demon_config);
    zh_CN.addAll(_cn_hyakkiyakou_config);
    zh_CN.addAll(_cn_kokan_config);

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
        I18n.setup_deploy: '服务启动配置',
        I18n.setup_log: '服务启动日志',
        I18n.execute_update: '手动更新',
        I18n.go_oasx_release: '点击下载',
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
        I18n.meta_demon: '超鬼王',
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
window_background ~= nemu_ipc >>> DroidCast_raw >  ADB_nc >> DroidCast > uiautomator2 ~= ADB
使用window_background来截图是10ms左右，对比DroidCast_raw是100ms左右（仅限作者的电脑）。但是window_background有一个致命的缺点是模拟器不可以最小化，
nemu_ipc仅限mumu12模拟器且要求版本大于3.8.13，并且需要设置模拟器的执行路径''',
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
基于优先级(Priority)的调度：高优先级先于低优先级执行，同优先级按照先来后到顺序''',
        'emulatorinfo_path': '模拟器路径',
        'emulatorinfo_path_help':
            '举例："E:\ProgramFiles\MuMuPlayer-12.0\shell\MuMuPlayer.exe"',
      };
  Map<String, String> get _cn_restart => {
        I18n.harvest_config: '收菜配置',
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
        'tasks_config_reset': '重置所有计划任务',
        'reset_task_datetime_enable': '重置所有任务的下一次运行时间',
        'reset_task_datetime_enable_help': '勾选立即执行，记得反选掉',
        'reset_task_datetime': '重设的时间',
        'rest_task_datetime_help': '',
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
        'costume_config': '游戏装饰自定义',
        'costume_main_type': '庭院皮肤',
        'costume_main_type_help': '宠物屋不可用：[暖池青苑]、[枫色秋庭]',
        'costume_realm_type': '结界皮肤',
        'costume_realm_type_help': '测试阶段',
        'costume_theme_type': '主题',
        'costume_theme_type_help': '庭院最右下角的展开按钮',
        'costume_shikigami_type': '幕间',
        'costume_shikigami_type_help': '就是式神录',
        'costume_sign_type': '签到主题',
        'costume_sign_type_help': '',
        'costume_battle_type': '战斗主题',
        'costume_battle_type_help': '',
        // ---------------------------------------------------------------------
        'costume_main': '初语谧景',
        'costume_main_1': '织梦莲庭',
        'costume_main_2': '琼夜淬光',
        'costume_main_3': '烬夜韶阁',
        'costume_main_4': '笔墨山河',
        'costume_main_5': '枫色秋庭',
        'costume_main_6': '暖池青苑',
        'costume_main_7': '盛夏幽庭',
        'costume_main_8': '远海航船',
        // ---------------------------------------------------------------------
        'costume_realm_default': '妖扇结界',
        'costume_realm_1': '鬼灵咒符',
        'costume_realm_2': '狐梦之乡',
        'costume_realm_3': '编心织忆',
        'costume_realm_4': '花海繁生',
        'costume_realm_5': '5555',
        // ---------------------------------------------------------------------
        'costume_theme_default': '伊始之卷',
        // ---------------------------------------------------------------------
        'costume_shikigami_default': '静栖走廊',
        // ---------------------------------------------------------------------
        'costume_sign_default': '默认',
        // ---------------------------------------------------------------------
        'costume_battle_default': '默认',
      };

  Map<String, String> get _cn_raid_config => {
        'raid_config': '突破配置',
        'skip_difficult': '跳过难度较高的结界',
        'skip_difficult_help': '失败后不再攻打该结界',
        'ryou_access': '寮管理开启寮突破',
        'ryou_access_help': '',
        'random_delay': '随机延迟',
        'random_delay_help': '正式进攻会设定 2s - 10s 的随机延迟，避免攻击间隔及其相近被检测为脚本。',
      };

  Map<String, String> get _cn_invite_config => {
        'invite_config': '通用邀请配置',
        'invite_number': '邀请人数',
        'invite_number_help': '作为队长时有效，可选1或者2，为1时只会邀请第一个队友,',
        'friend_1': '第一个队友名字',
        'friend_2': '第二个队友名字',
        'friend_name_help':
            '输入队友的名字必须是全称，这一项是基于OCR来识别，如果名字过于离谱建议画200勾玉改一个正常点的名字',
        'friend_2_name_help': '同上',
        'find_mode': '寻找队友模式',
        'find_mode_help':
            '默认会从上方列表自动寻找 \n"好友" -> "最近" -> "聊友" -> "跨区"，当然建议选择‘recent_friend’这样会快点',
        'wait_time': '等待时间',
        'wait_time_help': '保持默认一分钟就好，期间每隔20s邀请一次',
        'default_invite': '战斗结束后勾选默认邀请',
        'default_invite_help': '',
      };

  Map<String, String> get _cn_general_battle_config => {
        'general_battle_config': '通用战斗配置',
        'lock_team_enable': '锁定阵容',
        'lock_team_enable_help': '如果锁定阵容将无法启用预设队伍、加成功能',
        'preset_enable': '启用切换预设队伍',
        'preset_enable_help': '将会在第一次战斗的时候切换队伍预设',
        'preset_group': '第 X 个预设组',
        'preset_group_help': '可选[1~7]',
        'preset_team': '第 X 个预设队伍',
        'preset_team_help': '可选[1~5]',
        'green_enable': '启用我方绿标',
        'green_enable_help': '在战斗开始的一瞬间点击绿标，无反馈点击',
        'green_mark': '设置第 X 个式神为绿标',
        'green_mark_help': '可选[左一, 左二, 左三, 左四, 左五, 主阴阳师]',
        'random_click_swipt_enable': '战斗时随机点击或者随机滑动',
        'random_click_swipt_enable_help':
            '防封优化，每三分钟的战斗可能触发0~8次，请注意这个与绿标功能冲突，可能会乱点绿标',
      };

  Map<String, String> get _cn_switch_soul => {
        'switch_soul': '执行任务前切换御魂',
        'switch_soul_config': '执行任务前切换御魂',
        'switch_group_team': '御魂装配分组设置',
        'switch_group_team_help': '''初始值是不合适的，你需要根据自己的情况设置
"1,2"表示第一个预设组，第二个队伍
请使用英文输入法下的逗号
预设组支持[1-7], 预设队伍支持[1-4]''',
        'enable_switch_by_name': '通过OCR来切换御魂预设',
        'enable_switch_by_name_help':
            '这是切换御魂的另一种方式，对比上方的方式而言支持更多的预设，但是同样的你还确保预设队伍是锁定状态的',
        'group_name': '御魂分组名',
        'team_name': '队伍名',
      };

  Map<String, String> get _cn_orochi_config => {
        'orochi_config': '副本设置',
        'user_status': '身份',
        'user_status_help': '可选队长、队员、单独刷（野队还不打算实现）',
        'layer': '挑战层数',
        'layer_help': '',
        'limit_time': '限制运行时间',
        'limit_time_help': '',
        'limit_count': '限制挑战次数',
        'limit_count_help':
            '两个限制需要同时设置，最先达到就会退出。建议执行时间设置成一个小时足够长，此时基于次数来判定设置为100次',
        'soul_buff_enable': '开启御魂加成',
        'soul_buff_enable_help': '会在庭院开始的时候设置加成',
      };

  Map<String, String> get _cn_sougenbi_config => {
        'sougenbi_config': '业原火配置',
        'sougenbi_class': '挑战类型',
        'buff_enable': '开启加成',
        'buff_gold_50_click': '开启金币加成50%',
        'buff_gold_100_click': '开启金币加成100%',
        'buff_exp_50_click': '开启经验加成50%',
        'buff_exp_100_click': '开启经验加成100%',
      };

  Map<String, String> get _cn_fallen_sun_config => {
        'fallen_sun_config': '日轮之城',
      };
  Map<String, String> get _cn_eternity_sea_config => {
        'eternity_sea_config': '永生之海',
        'switch_soul_config_2': '切换御魂配置',
      };
  Map<String, String> get _cn_dragon_spine_config => {
        'trifles_config': '每日琐事',
        'one_summon': '每日召唤',
        'guild_wish': '寮祈愿（还不知道可以写什么）',
        'friend_love': '友情点',
        'store_sign': '商店签到',
        'store_sign_help': '就那个签到50次得黑蛋的',
      };

  Map<String, String> get _cn_area_boss_config => {
        'boss': '鬼王',
        'boss_number': '鬼王挑战数量',
        'general_battle': '通用战斗',
      };

  Map<String, String> get _cn_gold_youkai_config => {
        'gold_youkai': '金币妖怪',
      };
  Map<String, String> get _cn_nian_config => {
        'nian_config': '年兽配置',
      };
  Map<String, String> get _cn_talisman_config => {
        'talisman': '花合战',
        'level_reward': '选择礼盒',
      };
  Map<String, String> get _cn_pets_config => {
        'pets_config': '小猫咪',
        'pets_happy': '其乐融融',
        'pets_feast': '饕餮大餐',
      };
  Map<String, String> get _cn_simple_tidy_config => {
        'simple_tidy': '简易御魂清理',
        'greed_maneki': '贪吃鬼喂食+未升级的御魂奉纳',
        'greed_maneki_help': '建议四星及一下的吃掉，五星的留给贪吃鬼',
      };
  Map<String, String> get _cn_delegation_config => {
        'delegation_config': '委派',
        'miyoshino_painting': '弥助的画',
        'miyoshino_painting_help': '300体力->六星变异卡',
        'bird_feather': '鸟之羽',
        'bird_feather_help': '50体力->20片大蛇的逆鳞',
        'find_earring': '寻找耳环',
        'find_earring_help': '300体力->金币28万',
        'cat_boss': '猫老大',
        'cat_boss_help': '300体力->四星白蛋',
        'miyoshino': '接送弥助',
        'miyoshino_help': '100体力->三星结界卡',
        'strange_trace': '奇怪的痕迹',
        'strange_trace_help': '100体力->金币九万八',
      };
  Map<String, String> get _cn_wanted_quests_config => {
        'wanted_quests_config': '悬赏封印',
        'before_end': '强制设定悬赏刷新前 X 分钟执行',
        'before_end_help': '默认[00:00:00]表示不使用这个功能，不可取负值，建议最后一小时才执行悬赏[01:00:00]',
        'invite_friend_name': '协作任务邀请特定人员',
        'cooperation_type': '邀请好友协作类型',
        'invite_friend_name_help': '填写朋友昵称,无法区分不同服务器相同昵称好友, 仅单个好友',
        'cooperation_type_help': '',
        'NoInvite': '不邀请',
        'GoldOnly': '仅金币',
        'JadeOnly': '仅勾协',
        'GoldAndJade': '金币和勾协',
        'FoodOnly': '仅食协',
        'GoldAndFood': '金币+食协',
        'JadeAndFood': '勾协+食协',
        'GoldAndJadeAndFood': '金币+勾协+食协',
        'SushiOnly': '仅体协',
        'GoldAndSushi': '金币+体协',
        'JadeAndSushi': '勾协+体协',
        'GoldAndJadeAndSushi': '金币+勾协+体协',
        'FoodAndSushi': '食协+体协',
        'GoldAndFoodAndSushi': '金币+食协+体协',
        'JadeAndFoodAndSushi': '勾协+食协+体协',
        'Any': '全部'
      };
  Map<String, String> get _cn_tako_config => {
        'tako_config': '石距',
      };
  Map<String, String> get _cn_bondling_config => {
        'bondling_config': '契灵之境',
        'bondling_mode': '设置战斗策略',
        'bondling_mode_help': '''mode_1是指进行探查，刷到五个契灵后结束
mode_2策略是刷到五个契灵后一直进行结契战斗，但是选择低级盘来结契失败获取材料
mode_3策略是刷到五个契灵后开始结契，选择高级、中级盘来进行捕获''',
        'bondling_stone_enable': '是否使用契石召唤契灵',
        'bondling_stone_enable_help': '会优先开启契石，之后才是探查',
        'bondling_stone_class': '使用契石时选择召唤类型',
        'bondling_stone_class_help': '',
        'bondling_switch_soul': '契灵之境切换御魂',
        'auto_switch_soul': '是否启用',
        'auto_switch_soul_help':
            '如果你有5套独立阵容，那么这一项无需开启,否则你可以开启这一项御魂轮换（探查是默认不需要轮换的）',
        'tomb_guard_switch': '设置镇墓兽的御魂装配分组',
        'tomb_guard_switch_help': '',
        'snowball_switch': '设置茨球的御魂装配分组',
        'snowball_switch_help': '',
        'little_kuro_switch': '设置小黑的御魂装配分组',
        'little_kuro_switch_help': '',
        'azure_basan_switch': '设置火灵的御魂装配分组',
        'azure_basan_switch_help': '',
        'battle_config': '战斗设置',
      };
  Map<String, String> get _cn_evo_zone_config => {
        'evo_zone_config': '觉醒副本',
        'kirin_type': '麒麟选择',
        'kirin_type_help': '',
      };
  Map<String, String> get _cn_goryou_config => {
        'goryou_config': '御灵之境',
        'goryou_class': '挑战类型',
        'goryou_class_help': '',
      };
  Map<String, String> get _cn_exploration_config => {
        'exploration_config': '探索副本',
        'attack_number': '通关次数',
        'current_exploration_times': 'current_exploration_times',
        'exploration_level': '探索章节',
        'auto_rotate': '自动添加候补式神',
        'choose_rarity': '自动添加候补式神种类',
      };
  Map<String, String> get _cn_utilize_config => {
        'utilize_config': '结界蹭卡配置',
        'utilize_rule': '寄养规则',
        'utilize_rule_help':
            '挑选结界卡的规则，使用默认default即可，具体规则看文档[任务列表]，不可以选auto,已经弃置了。',
        'select_friend_list': '选择同区还是跨区好友',
        'select_friend_list_help':
            '''由于该死的游戏制作水准，无论任何方式都不可以稳定的对结界卡进行排序，需要从头到尾遍历一遍。
且切换好友列表时候会丢失原先选定的好友卡，为此同时选择两个好友列表的最优解是会花费更多的时间，不打算支持''',
        'shikigami_class': '寄养式神类型',
        'shikigami_class_help': '选择的式神类别（寄养默认选择N卡，且不建议选别的）',
        'shikigami_order': '选中第几个式神寄养',
        'shikigami_order_help': '从左开始选第几个式神',
        'guild_ap_enable': '顺路收取寮补给',
        'guild_ap_enable_help': '必选项',
        'guild_assets_enable': '顺路收取寮资金',
        'guild_assets_enable_help': '必选项',
        'box_ap_enable': '顺路收取体力盒子',
        'box_ap_enable_help': '必选项',
        'box_exp_enable': '顺路收取经验盒子',
        'box_exp_enable_help': '必选项',
        'box_exp_waste': '从盒子提取经验时浪费一部分',
        'box_exp_waste_help':
            '某些时候寄养上存在满级的式神，收取经验盒子时会有提示，对于挂机玩家这点经验微不足道。如果不使能这一选项，将跳过收取经验盒子',
      };

  Map<String, String> get _cn_activation_config => {
        'activation_config': '结界挂卡',
        'card_rule': '放卡规则',
        'card_rule_help': '必选项',
        'exchange_before': '收取经验前更换下来满级的式神',
        'exchange_before_help': '必选项',
        'exchange_max': '收取经验后更换下来满级的式神',
        'exchange_max_help': '必选项',
        'shikigami_class': '寄养式神类型',
        'shikigami_class_help': '选择的式神类别（寄养默认选择N卡，且不建议选别的）',
      };

  Map<String, String> get _cn_realm_raid_config => {
        'number_attack': '挑战次数',
        'number_attack_help': '默认30，可选范围[1~30]，没有挑战卷自动退出任务（标记为成功）',
        'number_base': '突破卷数量大于等于 X 时才会挑战',
        'number_base_help': '旨在检查突破卷数量，如果当前的数量没有大于等于这个值，将标记为成功并退出',
        'exit_four': '当进攻到左上角第一个的时候先退四次再进攻',
        'exit_four_help': '为了支持打九退四，保证稳定57级',
        'order_attack': '挑战顺序',
        'order_attack_help': '使用过滤器，保持默认即可',
        'three_refresh': '每三次就刷新',
        'three_refresh_help': '挑战进度到三，领取奖励后就刷新，如果刷新操作进入CD，将标记为失败并退出',
        'when_attack_fail': '挑战失败时',
        'when_attack_fail_help': '''Exit：直接退出任务，标记为失败
Continue：挑战其他的直至没有可挑战的才刷新
Refresh：直接刷新，如果刷新操作进入CD，将标记为失败并退出''',
      };

  Map<String, String> get _cn_missions_config => {
        'missions_config': '集体任务',
        'missions_rule': '任务选择优先级',
        'missions_rule_help': '',
        'setup_when_bondling': '执行契灵任务是唤起',
        'setup_when_bondling_help': '',
      };
  Map<String, String> get _cn_hunt_config => {
        'hunt_config': '狩猎战',
        'kirin_group_team': '麒麟御魂切换',
        'netherworld_group_team': '阴界之门御魂切换',
      };
  Map<String, String> get _cn_true_orochi_config => {
        'true_orochi_config': '真蛇配置',
        'find_true_orochi': '挑战御魂十层触发真蛇',
        'find_true_orochi_help':
            '''启用这一项，没有出现八岐大蛇时会单独挑战十层十次，如果还不出现判断失败，将会设置失败时的间隔到下一次来进行开启任务
如果不启用这一项，没有发现真蛇时直接判定运行失败''',
        'current_success': '本周已经挑战成功的次数',
        'current_success_help': '请不要手动修改这一项，是为了给机器计数的，机器会自动修改',
      };
  Map<String, String> get _cn_rich_man_config => {
        'special_room': '[杂货铺]特殊购买',
        'totem_pass': '御灵券(40张)',
        'medium_bondling_discs': '千咒式盘',
        'medium_bondling_discs_special': '契灵中级盘，可选[0~100]',
        'low_bondling_discs': '百物式盘',
        'low_bondling_discs_special': '契灵低级盘，可选[0~100]',
        'honor_room': '[杂货铺]荣誉购买',
        'mystery_amulet': '神秘咒符',
        'mystery_amulet_help_honor': '默认买两个',
        'black_daruma_scrap': '黑蛋碎片',
        'black_daruma_scrap_help_honor': '默认买两个',
        'friendship_points': '[杂货铺]友情点购买',
        'white_daruma': '奉为达摩',
        'red_daruma': '招福达摩',
        'broken_amulet': '破碎的咒符',
        'medal_room': '[杂货铺]勋章购买',
        'black_daruma': '破碎的咒符',
        'ap_100': '体力100',
        'random_soul': '随机御魂',
        'challenge_pass_help': '可选[0~10]',
        'challenge_pass': '挑战券',
        'charisma': '[杂货铺]魅力值购买',
        'thousand_things': '千物宝箱',
        'black_daruma_fragment': '御行达摩碎片',
        'ap': '体力',
        'ap_help': '默认买两次不够就不买',
        'consignment': '寄售屋',
        'buy_sale_ticket': '兑换一百张寄售券',
        'buy_sale_ticket_help': '等凑够了再去换',
        'scales': '御魂礼盒',
        'orochi_scales': '朴素御魂',
        'orochi_scales_help': '可选[0~40]',
        'demon_souls': '首领御魂',
        'demon_souls_help': '可选[0~50]',
        'demon_class': '首领御魂类型',
        'demon_class_help': '不支持多个首领',
        'demon_position': '首领御魂号位',
        'demon_position_help': '不支持多号位',
        'picture_book_scrap': '海汐御魂',
        'picture_book_scrap_help': '可选[0~30]',
        'picture_book_rule': '选择御魂优先级',
        'picture_book_rule_help': '使用auto即可',
        'bondlings': '契忆商店',
        'random_soul_help': '可选[0~100]',
        'bondling_stone': '鸣契石',
        'bondling_stone_help': '可选[0~10]',
        'high_bondling_discs': '万象式盘',
        'high_bondling_discs_help': '可选[0~50]',
        'medium_bondling_discs_help': '可选[0~20]',
        'shrine': '神龛',
        'white_daruma_five': '五星白蛋',
        'white_daruma_four': '四星白蛋',
        'guild_store': '[寮]功勋商店',
        'skin_ticket': '皮肤券',
        'skin_ticket_help': '可选[0~5]',
      };

  Map<String, String> get _cn_secret_config => {
        'secret_config': '秘闻之境',
        'secret_gold_50': '金币加成50%',
        'secret_gold_50_help': '这将会在低层[1-5]自动打开加成并且自动关闭加成',
        'secret_gold_100': '金币加成100%',
        'secret_gold_100_help': '同上',
        'layer_10': '挑战十层',
        'layer_10_help': '考虑到练度，这将不是默认打开的',
        'layer_9': '挑战九层',
      };

  Map<String, String> get _cn_trifles_config => {
        'trifles': '每周必选',
        'share_collect': '图鉴分享',
        'share_collect_help': '每周一张票、不要白不要',
        'share_area_boss': '地鬼分享',
        'share_area_boss_help': '没什么建议，勾上就对了',
        'share_secret': '秘闻分享',
        'share_secret_help': '建议在秘闻结束后再来执行这个任务',
        'trifles_broken_amulet_help': '建议设置较大的数值以每周清空',
      };

  Map<String, String> get _cn_shop_config => {
        'shop_config': '购买',
        'time_of_mystery': '强制设定出现神秘商店当天的执行时间',
        'time_of_mystery_help':
            '限定[00:00:01-23:30:00],这将使你无视掉调度器的Interval。保持默认[00:00:00]表示不使用',
        'shop_kaiko_3': '三星太鼓',
        'shop_kaiko_4': '四星太鼓',
        'share_config': '分享配置',
        'share_friend_1': '第一个好友名字',
        'share_friend_1_help': '使用OCR来识别，留空表示不使用',
        'share_friend_2': '第二个好友名字',
        'share_friend_3': '第三个好友名字',
        'share_friend_4': '第四个好友名字',
        'share_friend_5': '第五个好友名字',
      };

  Map<String, String> get _cn_duel_config => {
        'duel_config': '自动斗技',
        'switch_all_soul': '一键切换斗技御魂',
        'switch_all_soul_help': '你应当先进行式神御魂的导入',
        'target_score': '达到 X 分数后会结束任务',
        'target_score_help': '3000以上表示为名士（也是自动斗技的最高）',
        'honor_full_exit': '刷满荣誉就退出',
        'honor_full_exit_help': '这无需关心本周荣誉的上限是什么',
      };
  Map<String, String> get _cn_general_climb_config => {
        'general_climb': '通用爬塔',
        'ap_game_max': '活动每日使用体力挑战的最大次数',
        'ap_game_max_help': '保持默认300即可',
        'ap_mode': '挂体力模式',
        'ap_mode_help': '设置是挂活动的次数(ap_activity)还是游戏的体力(ap_game)',
        'activity_toggle': '挂完活动次数后切换到体力模式',
        'activity_toggle_help': '该设置只有是设定为活动次数时有效',
        'battle_mode': '战斗模式',
        'battle_mode_help': '',
      };

  Map<String, String> get _cn_meta_demon_config => {
        'meta_demon_config': '超鬼王配置',
        'auto_tea': '自动喝茶',
        'auto_tea_help': '',
        'extreme_notify': '最高等级鬼王不打而是发送通知',
        'extreme_notify_help': '',
        'interval': '执行任务后设定经过 X 时间后执行',
        'interval_help': '',
      };

  Map<String, String> get _cn_hyakkiyakou_config => {
        'Hyakkiyakou': '百鬼夜行',
        'hyakkiyakou_config': '百鬼配置',
        'hya_limit_time': '限制任务百鬼执行时间',
        'hya_limit_time_help': '',
        'hya_limit_count': '百鬼砸 X 张票子',
        'hya_limit_count_help': '',
        'hya_invite_friend': '是否邀请好友',
        'hya_invite_friend_help': '',
        'hya_auto_bean': '自动切换豆子数量',
        'hya_auto_bean_help': '默认全局十个豆子',
        'hya_priorities': '最高优先级',
        'hya_priorities_help': '正所谓我的代码在你之上，查阅文档找到对应的label，使用逗号分隔开',
        'hya_sp': 'SP卡权重',
        'hya_sp_help': '保持默认即可',
        'hya_ssr': 'SSR',
        'hya_ssr_help': '',
        'hya_sr': 'SR',
        'hya_sr_help': '',
        'hya_r': 'R',
        'hya_r_help': '',
        'hya_n': 'N',
        'hya_n_help': '',
        'hya_g': 'G',
        'hya_g_help': '呱太，单独从N卡分出来',
        'hyakkiyakou_models': '模型设置',
        'conf_threshold': '置信度阈值',
        'conf_threshold_help': '用来筛选检测结果,置信度得分越高，表示模型越确信该框中包含目标',
        'iou_threshold': '非极大值抑制(NMS)阈值',
        'iou_threshold_help':
            '后处理技术，用于减少检测结果中的冗余框。当检测到多个重叠的框时，NMS选择一个最优的框，并抑制（去除）其他重叠度较高的框。',
        'model_precision': '模型精度',
        'model_precision_help': '32位浮点型和8位整形，后者使用精度换取速度，大约有1~4倍的提速(看机器)',
        'inference_engine': '推理引擎',
        'inference_engine_help':
            '使用CPU(Onnxruntime)还是GPU(TensorRT), TensorRT依赖Cuda环境，详情看文档',
        'debug_config': '调试配置',
        'hya_show': '运行期间显示目标检测及跟踪',
        'hya_show_help': '众所周知，开启额外的功能将会额外带来性能占用',
        'hya_info': '显示更多日志',
        'hya_info_help': '',
        'continuous_learning': '回馈学习',
        'continuous_learning_help':
            '将会保存有价值的图片在"./log/hya"，应当将这些图片上传到群文件，用于优化模型~比心( ´ ▽ ` ).｡ｏ♡',
        'hya_save_result': '保存每一次砸百鬼的最终收获',
        'hya_save_result_help': '将会保存图片在"./log/hyakkiyakou"',
        'hya_interval': '限制最短截屏时间',
        'hya_interval_help': '单位ms， 最少100',
      };
  Map<String, String> get _cn_kokan_config => {
        'Dokan': '道馆',
        'dokan_config': '道馆配置',
        'dokan_attack_priority': '攻击优先顺序',
        'dokan_attack_priority_help': '见习=0,初级=1...',
        'dokan_auto_cheering_while_cd': '失败CD后自动加油',
        'dokan_auto_cheering_while_cd_help': '',
      };
}
