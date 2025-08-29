part of i18n;

final Map<String, String> _us_base_map = {
  ..._us_ui,
  ..._us_script,
  ..._us_global_game,
  ..._us_restart,
  ..._us_invite_config,
  ..._us_general_battle_config,
  ..._us_switch_soul,
};

final Map<String, String> _us_ui = {
  I18n.log_out: 'Logout',
  I18n.zh_cn: '简体中文',
  I18n.en_us: 'English',
  I18n.project_statement: 'Open Source Software',
  I18n.task_setting: 'Settings',
  I18n.notify_test_help: 'Please refer to the documentation [Message Push] to fill in the relevant configuration',
  I18n.root_path_server_help:
  'OASX and OAS are two different things. Do not confuse them, do not put them in the same directory, do not use spaces, do not use Chinese characters, and do not use overly long paths',
  I18n.install_oas_help: 'This will download and decompress from Github. Please maintain a stable network connection. At the same time, this directory will be cleared',
  I18n.config_update_tip: 'The current script is running, please stop it before making modifications.',
};

final Map<String, String> _us_script = {
  I18n.serial_help: '''Common emulator serials can be found in the list below. 
Fill in "auto" to automatically detect the emulator. When multiple emulators are running or an emulator that does not support automatic detection is used, "auto" cannot be used and must be filled in manually.
  
Default emulator serials: 
[MuMu Player 12]: 127.0.0.1:16384 
[MuMu Player]: 127.0.0.1:7555 
[LDPlayer](all series): emulator-5554 or 127.0.0.1:5555
If it's not mentioned, it may not have been tested or is not recommended. You can try it yourself. 
If you use the multi-instance function of the emulator, their serials will not be the default. You can query them by executing adb devices in console.bat, or fill them in according to the official emulator tutorial''',
  I18n.handle_help:
  '''Fill in "auto" to automatically detect the emulator. "auto" cannot be used when multiple emulators are running or when using an emulator that does not support automatic detection; it must be filled in manually. The input is the handle title or handle number. The handle number changes each time the emulator is started. Clearing it means not using the window operation method.

Handle Title: 
[MuMu Player 12]: "MuMu Player 12" 
[MuMu Player]: "MuMu Player" 
[LDPlayer](all series): "LDPlayer"

Handle Number: 
Some emulators have the same handle title when multiple instances are opened (referring to MuMu). In this case, you need to manually obtain the emulator's handle number and set it manually. 
Please refer to the documentation for tools to obtain it: [Emulator Support]''',
  I18n.package_name_help: 'When multiple game clients are installed on the emulator, you need to manually select the server',
  I18n.screenshot_method_help: '''When automatic selection is used, a performance test will be performed once, and it will automatically change to the fastest screenshot solution. The general speed is: 
window_background ~= nemu_ipc >>> DroidCast_raw > ADB_nc >> DroidCast > uiautomator2 ~= ADB 
Using window_background for screenshots is about 10ms, compared to DroidCast_raw which is about 100ms (only on the author's computer). However, window_background has a fatal flaw: the emulator cannot be minimized. 
nemu_ipc is limited to MuMu Player 12 and requires a version greater than 3.8.13, and the emulator's execution path needs to be set''',
  I18n.control_method_help:
  '''Speed: window_message ~= minitouch > Hermit >>> uiautomator2 ~= ADB 
The control method simulates human speed, and faster is not always better. Using (window_message) may occasionally fail''',
  I18n.emulatorinfo_type_help: '''Select the type of emulator you are using''',
  I18n.emulatorinfo_name_help: '''Example: MuMuPlayer-12.0-0, if unclear, please consult the documentation''',
  I18n.adb_restart_help: '',
  I18n.notify_config_help: 'Input is in YAML format, there is a space after the colon ":", for details please refer to the documentation [Message Push]',
  I18n.screenshot_interval_help:
  'The minimum interval between two screenshots, limited to 0.1 ~ 0.3, can reduce CPU usage for high-configuration computers',
  I18n.combat_screenshot_interval_help:
  'The minimum interval between two screenshots, limited to 0.1 ~ 1.0, can reduce CPU usage during battles',
  I18n.task_hoarding_duration_help:
  'Can reduce the frequency of game operations during farming periods. After a task is triggered, wait X minutes, then execute the accumulated tasks all at once',
  I18n.when_task_queue_empty_help: 'Close the game when there are no tasks, which can reduce CPU usage during farming periods',
  I18n.schedule_rule_help: '''The scheduling objects referred to here are those in Pending; tasks in Waiting are not included. 
Filter-based scheduling: The default option. The execution order of tasks will be scheduled according to the order determined during development, which is generally the optimal solution. 
First-In, First-Out (FIFO)-based scheduling: Tasks will be sorted by their next execution time, and those at the front will be executed first. 
Priority-based scheduling: High-priority tasks are executed before low-priority tasks. Tasks with the same priority are executed in a first-come, first-served order''',
  'emulatorinfo_path_help':
  'Example: "E:\\ProgramFiles\\MuMuPlayer-12.0\\shell\\MuMuPlayer.exe"',
};

final Map<String, String> _us_restart = {
  I18n.enable_help: 'Add this task to the scheduler',
  I18n.next_run_help: 'The time will be automatically calculated based on the interval below',
  I18n.priority_help:
  'This option is valid if the scheduling rule is set to priority-based. The default is 5. The lower the number, the higher the priority. The range is [1-15]. If the priority is the same, tasks are scheduled on a first-come, first-served basis',
  I18n.success_interval_help: '',
  I18n.failure_interval_help: '',
  I18n.server_update_help:
  'If it\'s not set to the default "09:00:00", the task will forcibly set the next run time to the set value of the next day after each execution',
  I18n.harvest_enable_help: 'This section is for automatically clicking on login rewards when logging into the game. It is a required option',
  'rest_task_datetime_help': '',
  'delay_date_help': 'When the forced execution time is enabled above, customize how many days later to enforce execution. By default, it\'s one day later, meaning the next day',
  'float_time_help':
  'To prevent account suspension, the next run time will be randomly delayed within this range; generally, three to five minutes is sufficient. When forced execution is enabled, ensure it does not exceed the window: for example, Kirin at 19:00 + 2 minutes, Demon Encounter at 17:00 + 1.5 hours, to avoid affecting other tasks',
};

final Map<String, String> _us_global_game = {
  I18n.friend_invitation_help: 'Accept all by default',
  'accept_invitation_complete_now_help': 'To prevent cancellation by the other party due to two hours of inactivity, it is enabled by default',
  I18n.invitation_detect_interval_help: 'Detect collaboration every 10 seconds by default',
  I18n.when_network_abnormal_help: 'By default, it will wait for 10 seconds first',
  I18n.when_network_error_help: 'Restart the game',
  I18n.home_client_clear_help: 'Sometimes it may require clearing the cache when entering the courtyard',
  I18n.enable_help: 'Add this task to the scheduler',
  I18n.broker_help: '',
  I18n.port_help: '',
  I18n.transport_help: '',
  I18n.ca_help: '',
  I18n.username_help: '',
  I18n.password_help: '',
  // ---------------------------------------------------------------------
  'costume_main': 'On Tranquil Views',
  'costume_main_1': 'Celestial Garden',
  'costume_main_2': 'Luminescent Night',
  'costume_main_3': 'Melodic Pavilion',
  'costume_main_4': 'Painted Panorama',
  'costume_main_5': 'Autumn Maples',
  'costume_main_6': 'Hot Spring',
  'costume_main_7': 'Summer Nights',
  'costume_main_8': 'Far-sailing Ship',
  // ---------------------------------------------------------------------
  'costume_realm_default': 'Umbrella Sanctuary',
  'costume_realm_1': 'Demon Spirit Charms',
  'costume_realm_2': 'Fox\'s Defensive Realm',
  'costume_realm_3': 'Threaded Memories',
  'costume_realm_4': 'Sea of Flowers',
  // ---------------------------------------------------------------------
  'costume_battle_1': 'Realm of Melodies',
};

final Map<String, String> _us_invite_config = {
  'invite_number_help': 'This is effective when you are the team leader. You can choose 1 or 2. If you choose 1, only the first teammate will be invited',
  'friend_name_help': 'When inputting your teammate\'s name, it must be the full name. This is based on OCR recognition, so if the name is too unusual, it\'s recommended to spend 200 Jade to change it to something more standard',
  'friend_2_name_help': 'Same as above',
  'find_mode_help':
  'By default, it will automatically search from the list above: \n"Friend" -> "Recent" -> "Guildmate" -> "Cross-server". Of course, it is recommended to select ‘recent_friend’ as this will be faster',
  'wait_time_help': 'Keep the default setting for one minute, and invite once every 20 seconds during this period',
  'default_invite_help': '',
};

final Map<String, String> _us_general_battle_config = {
  'lock_team_enable_help': 'If the team is locked, preset teams and buff features cannot be enabled',
  'preset_enable_help': 'The team preset will be switched during the first battle',
  'preset_group_help': 'Select[1~7]',
  'preset_team_help': 'Select[1~5]',
  'green_enable_help': 'Click the green mark at the moment the battle starts, with no feedback on the click',
  'green_mark_help': 'Select from [Left 1, Left 2, Left 3, Left 4, Left 5, Main Onmyoji]',
  'random_click_swipt_enable_help':
  'Anti-blocking optimization: may trigger 0-8 times in every three minutes of battle. Please note that this conflicts with the green mark function and may cause random clicks on the green mark',
};

final Map<String, String> _us_switch_soul = {
  'switch_group_team_help': '''The initial value is not suitable; you need to set it according to your own situation. 
'1,2' indicates the first preset group and the second team. 
Please use a comma from the English input method. 
Preset groups support [1-7], and preset teams support [1-4]''',
  'enable_switch_by_name_help':
  'This is another way to switch souls. Compared to the method above, it supports more presets, but similarly, you still need to ensure that the preset team is in a locked state',
};
