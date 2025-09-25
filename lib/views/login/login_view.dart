library login;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:oasx/api/api_client.dart';
import 'package:oasx/views/layout/appbar.dart';
import 'package:oasx/utils/platform_utils.dart';

part './login_binding.dart';
part '../../controller/login/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPlatformAppBar(context),
      floatingActionButton: PlatformUtils.isWindows ? _serverButton() : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: _login(context),
    );
  }

  Widget _login(BuildContext context) {
    List<double> maxWidthHigh = switch (Theme.of(context).platform) {
      TargetPlatform.windows => [400, 500],
      TargetPlatform.linux => [400, 500],
      TargetPlatform.macOS => [400, 500],
      _ => [],
    };
    return FormBuilder(
      key: _formKey,
      child: <Widget>[_admin(context), _address(), _username(), _password(), _signin()]
          .toColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center),
    )
        .padding(vertical: 10)
        // .card(
        //     elevation: 10,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ))
        .constrained(
            maxHeight: maxWidthHigh.isNotEmpty ? maxWidthHigh[0] : 500,
            maxWidth: maxWidthHigh.isNotEmpty ? maxWidthHigh[1] : 400)
        .alignment(Alignment.center);
  }

  Widget _admin(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Text(
      'Admin Login',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    ).padding(horizontal: 20);
  }

  Widget _username() {
    LoginController loginController = Get.find<LoginController>();
    return FormBuilderTextField(
      name: 'username',
      initialValue: loginController.username.value,
      decoration: const InputDecoration(labelText: 'Username'),
      // validator: FormBuilderValidators.compose([
      //   FormBuilderValidators.maxLength(1, errorText: "Account does not exist"),
      // ]),
    ).padding(horizontal: 20, top: 5);
  }

  Widget _password() {
    LoginController loginController = Get.find<LoginController>();
    return FormBuilderTextField(
      name: 'password',
      initialValue: loginController.password.value,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      // validator: FormBuilderValidators.compose([
      //   FormBuilderValidators.maxLength(1, errorText: "Incorrect password"),
      // ]),
    ).padding(horizontal: 20, top: 20);
  }

  Widget _address() {
    LoginController loginController = Get.find<LoginController>();
    return FormBuilderTextField(
      name: 'address',
      initialValue: loginController.address.value,
      decoration: const InputDecoration(labelText: 'Address'),
      // validator: FormBuilderValidators.compose([
      //   FormBuilderValidators.required(),
      //   FormBuilderValidators.match(RegExp(r"\\d+.\\d+.\\d+.\\d+:\\d+"),
      //       errorText: "Format: [ip]:[port]"),
      // ]),
    ).padding(horizontal: 20, top: 20);
  }

  Widget _signin() {
    LoginController loginController = Get.find<LoginController>();
    return ElevatedButton(
      onPressed: () async => {
        if (_formKey.currentState?.saveAndValidate() ?? false)
          {await loginController.toMain(data: _formKey.currentState!.value)}
      },
      child: const Text('Login'),
    ).padding(horizontal: 20, top: 40);
  }

  Widget _serverButton() {
    return FloatingActionButton(
        heroTag: 'SERVER',
        child: const Icon(Icons.developer_board_rounded),
        onPressed: () {
          Get.toNamed('/server');
        });
  }
}
