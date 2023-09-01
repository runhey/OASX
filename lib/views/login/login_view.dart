library login;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

part './login_binding.dart';
part '../../controller/login/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _login(),
    );
  }

  Widget _login() {
    return FormBuilder(
      key: _formKey,
      child: <Widget>[_admin(), _address(), _username(), _password(), _signin()]
          .toColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center),
    )
        .padding(vertical: 10)
        .card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ))
        .alignment(Alignment.center);
  }

  Widget _admin() {
    ThemeData theme = Get.theme;
    return Text(
      'Admin',
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
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(1, errorText: "Account does not exist"),
      ]),
    ).padding(horizontal: 20, top: 5);
  }

  Widget _password() {
    LoginController loginController = Get.find<LoginController>();
    return FormBuilderTextField(
      name: 'password',
      initialValue: loginController.password.value,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(1, errorText: "Incorrect password"),
      ]),
    ).padding(horizontal: 20, top: 20);
  }

  Widget _address() {
    LoginController loginController = Get.find<LoginController>();
    return FormBuilderTextField(
      name: 'address',
      initialValue: loginController.address.value,
      decoration: const InputDecoration(labelText: 'Address'),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.match("\\d+.\\d+.\\d+.\\d+:\\d+",
            errorText: "Format: [ip]:[port]"),
      ]),
    ).padding(horizontal: 20, top: 20);
  }

  Widget _signin() {
    LoginController loginController = Get.find<LoginController>();
    return ElevatedButton(
      onPressed: () => {
        if (_formKey.currentState?.saveAndValidate() ?? false)
          {loginController.toMain(data: _formKey.currentState!.value)}
      },
      child: const Text('Sign in'),
    ).padding(horizontal: 20, top: 40);
  }
}
