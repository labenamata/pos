import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/login/form_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: backgroundcolor,
            title: const Text(
              'LOGIN',
              style: TextStyle(color: textColor),
            )),
        body: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: const Column(children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 100,
              child: Icon(
                LineIcons.userAlt,
                size: 70,
                color: textColorInvert,
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            FormWidget(),
            SizedBox(
              height: defaultPadding,
            ),
            Text('* User Password Default adalah admin admin')
          ]),
        ),
      ),
    );
  }
}
