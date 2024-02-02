import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/user/komponen/form_user.dart';
import 'package:pos_app/page/user/user_list.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LineIcons.angleLeft)),
        title: const Text('User'),
      ),
      body: const UserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: const FormUser(
                      stat: 'new',
                    ),
                  ),
                );
              });
        },
        backgroundColor: primaryColor,
        child: const Icon(
          LineIcons.plus,
          color: textColorInvert,
        ),
      ),
    );
  }
}
