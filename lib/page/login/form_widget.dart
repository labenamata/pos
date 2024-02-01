import 'package:flutter/material.dart';
import 'package:pos_app/page/login/login_button.dart';
import 'package:pos_app/page/login/password_widget.dart';
import 'package:pos_app/page/login/username_widget.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const UsernameField(),
          const SizedBox(height: 15),
          const PasswordField(),
          const SizedBox(height: 15),
          LoginButton(formKey: _formKey),
        ],
      ),
    );
  }
}
