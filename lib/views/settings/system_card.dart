part of settings;

class SystemSettingsCard extends StatelessWidget {
  const SystemSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingCard(
      title: I18n.system_setting.tr,
      items: [
        SettingItem(
          left: Text(I18n.change_theme.tr),
          right: const ThemeSwitcher(),
        ),
        SettingItem(
          left: Text(I18n.change_language.tr),
          right: const LanguageToggle(),
        ),
        if (PlatformUtils.isDesktop)
          SettingItem(
            left: Text(I18n.remember_window_position_size.tr),
            right: const WindowStateSwitch(),
          ),
        if (PlatformUtils.isDesktop)
          SettingItem(
            left: Row(
              children: [
                Text(I18n.minimize_to_system_tray.tr),
                Tooltip(
                  message: I18n.minimize_to_system_tray_help.tr,
                  child: const Icon(Icons.help_outline, size: 16),
                ).paddingOnly(left: 5),
              ],
            ),
            right: const SystemTraySwitch(),
          ),
        SettingItem(
            left: Text('${I18n.current_version.tr}: ${GlobalVar.version}'),
            right: const CheckUpdateButton()),
      ],
    );
  }
}

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    return Obx(() {
      final isSelected = switch (localeService.language.value) {
        'zh-CN' => [true, false],
        'en-US' => [false, true],
        _ => [true, false],
      };
      return ToggleButtons(
        isSelected: isSelected,
        onPressed: (index) {
          localeService.switchLanguage(index == 0 ? 'zh-CN' : 'en-US');
        },
        borderRadius: BorderRadius.circular(10),
        children: [
          Text(I18n.zh_cn.tr).paddingSymmetric(horizontal: 10),
          Text(I18n.en_us.tr).paddingSymmetric(horizontal: 10),
        ],
      ).constrained(maxHeight: 40);
    });
  }
}

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() {
      return IconButton(
        onPressed: themeService.switchTheme,
        icon: const Icon(Icons.light_mode),
        selectedIcon: const Icon(Icons.dark_mode),
        isSelected: themeService.isDarkMode,
      );
    });
  }
}

class WindowStateSwitch extends StatelessWidget {
  const WindowStateSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final windowService = Get.find<WindowService>();
    return Obx(() => Switch(
          value: windowService.enableWindowState.value,
          onChanged: windowService.updateWindowStateEnable,
        ));
  }
}

class SystemTraySwitch extends StatelessWidget {
  const SystemTraySwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final windowService = Get.find<WindowService>();
    return Obx(() => Switch(
          value: windowService.enableSystemTray.value,
          onChanged: windowService.updateSystemTrayEnable,
        ));
  }
}

class CheckUpdateButton extends StatelessWidget {
  const CheckUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => await checkUpdate(showTip: true),
      child: Text(I18n.execute_update.tr),
    );
  }
}
