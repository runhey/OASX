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
              left: Text(I18n.auto_login_after_deploy.tr),
              right: const LoginAfterDeploySwitcher()),
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

void notifyTest() {
  Get.defaultDialog(
    title: I18n.notify_test.tr,
    content: const NotifyTest(),
  );
}

void updater() {
  Get.defaultDialog(
    title: I18n.updater.tr,
    content: const UpdaterView().constrained(maxWidth: 400, maxHeight: 400),
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
