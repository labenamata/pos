import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
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
  void initState() {
    super.initState();
    context.read<CartBloc>().add(GetCart());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        //backgroundColor: backgroundcolor,
        appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            centerTitle: true,
            //backgroundColor: backgroundcolor,
            title: const Text(
              'LOGIN',
            )),
        body: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
