import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_app/bloc/login/login_bloc.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/transaksi/transaksi_page.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.formKey}) : super(key: key);

  final dynamic formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.formStatus is FormSubmitting) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.formStatus is SubmissionFailed) {
          SubmissionFailed excep = state.formStatus as SubmissionFailed;
          Fluttertoast.showToast(msg: excep.exception);
        } else if (state.formStatus is SubmissionSuccess) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransaksiPage()),
            );
          });
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          //style: TextButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginSubmitted());
            }
          },
          child: const Text(
            'Masuk',
            //style: TextStyle(color: textColorInvert),
          ),
        );
      },
    );
  }
}
