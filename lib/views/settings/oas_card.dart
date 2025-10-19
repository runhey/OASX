part of settings;

class OasSettingsCard extends StatelessWidget {
  const OasSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingCard(
      title: 'OAS${I18n.setting.tr}',
      items: [
        SettingItem(
            left: Text(I18n.notify_test.tr),
            right: const Icon(Icons.input_rounded),
            onTap: notifyTest),
        if (PlatformUtils.isDesktop)
          SettingItem(
              left: Text(I18n.auto_deploy.tr), right: const DeploySwitcher()),
        if (PlatformUtils.isDesktop)
          SettingItem(
              left: Text(I18n.auto_login_after_deploy.tr),
              right: const LoginAfterDeploySwitcher()),
        SettingItem(
            left: Text(I18n.auto_run_script.tr),
            right: const AutoScriptButton()),
        SettingItem(
            left: Text(I18n.updater.tr),
            right: const Icon(Icons.input_rounded),
            onTap: updater),
        SettingItem(
          left: Text(I18n.kill_oas_server.tr),
          right: const Icon(Icons.input_rounded),
          onTap: killServer,
        ),
        SettingItem(
          left: Text(I18n.log_out.tr),
          right: const Icon(Icons.input_rounded),
          onTap: () => Get.offAllNamed('/login'),
        ),
      ],
    );
  }
}

void notifyTest() {
  Get.defaultDialog(
    title: I18n.notify_test.tr,
    content: const NotifyTest(),
  );
}

class DeploySwitcher extends StatelessWidget {
  const DeploySwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    return Obx(() {
      return Switch(
        value: settingsController.autoDeploy.value,
        onChanged: (nv) => settingsController.updateAutoDeploy(nv),
      );
    });
  }
}

class LoginAfterDeploySwitcher extends StatelessWidget {
  const LoginAfterDeploySwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    return Obx(() {
      return Switch(
        value: controller.autoLoginAfterDeploy.value,
        onChanged: (nv) => controller.updateAutoLoginAfterDeploy(nv),
      );
    });
  }
}

class AutoScriptButton extends StatelessWidget {
  const AutoScriptButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.defaultDialog(
            title: I18n.auto_run_script_list.tr,
            content: const SingleChildScrollView(
              child: AutoScriptDialogContent(),
            ).constrained(maxHeight: 250).card(),
          );
        },
        icon: const Icon(Icons.settings_rounded));
  }
}

void updater() {
  double screenWidth = Get.width;
  double screenHeight = Get.height;
  double proportionalWidth = screenWidth * 0.8;
  double proportionalHeight = screenHeight * 0.7;
  const double contentIdealMaxWidth = 700;
  double finalMaxWidth = min(contentIdealMaxWidth, proportionalWidth);
  double finalMaxHeight = proportionalHeight;
  Get.defaultDialog(
    title: I18n.updater.tr,
    content: const UpdaterView()
        .constrained(maxWidth: finalMaxWidth, maxHeight: finalMaxHeight),
  );
}

void killServer() {
  Get.defaultDialog(
    title: I18n.are_you_sure_kill.tr,
    onCancel: () {},
    onConfirm: () async {
      await Get.find<SettingsController>().killServer();
      Get.offAllNamed('/login');
    },
  );
}

class AutoScriptDialogContent extends StatelessWidget {
  const AutoScriptDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scriptService = Get.find<ScriptService>();
    final scriptList = scriptService.scriptModelMap.keys.toList();
    scriptList.sort();
    return scriptList
        .map((item) {
          return Obx(() {
            return <Widget>[
              Expanded(
                  child:
                      Text(item, maxLines: 1, overflow: TextOverflow.ellipsis)),
              Checkbox(
                value: scriptService.autoScriptList.contains(item),
                onChanged: (nv) => scriptService.updateAutoScript(item, nv),
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                .paddingSymmetric(vertical: 4, horizontal: 8);
          });
        })
        .toList()
        .toColumn(mainAxisSize: MainAxisSize.min);
  }
}
