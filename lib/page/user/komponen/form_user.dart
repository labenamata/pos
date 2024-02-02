import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_app/bloc/user/user_bloc.dart';
import 'package:pos_app/constant.dart';

final userForm = GlobalKey<FormState>();
List<String> statusUser = <String>['admin', 'kasir', 'waiter'];

class FormUser extends StatefulWidget {
  final String stat;
  final int? id;
  final String? nama;
  final String? username;
  final String? password;
  final String? stUser;
  const FormUser(
      {super.key,
      required this.stat,
      this.nama,
      this.username,
      this.password,
      this.stUser,
      this.id});

  @override
  State<FormUser> createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  late String userStatus;
  TextEditingController namaController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.stat == 'edit') {
      namaController.text = widget.nama!;
      userController.text = widget.username!;
      passController.text = widget.password!;
      userStatus = widget.stUser!;
    } else {
      userStatus = statusUser.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: userForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.stat == 'edit' ? 'Edit User' : 'Tambah User'),
            const SizedBox(
              height: defaultPadding,
            ),
            customTextField(
                validator: 'Masukan Nama User',
                label: 'Nama',
                controller: namaController),
            const SizedBox(
              height: defaultPadding,
            ),
            customTextField(
                validator: 'Masukan Username',
                label: 'Username',
                controller: userController),
            const SizedBox(
              height: defaultPadding,
            ),
            customTextField(
                validator: 'Masukan Password',
                label: 'Password',
                obs: true,
                controller: passController),
            const SizedBox(
              height: defaultPadding,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              dropdownColor: backgroundcolor,
              value: userStatus,
              onChanged: (String? newValue) {
                setState(() {
                  userStatus = newValue!;
                });
              },
              items: statusUser.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    //style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: primaryColor, width: 2)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: textColor),
                  ),
                )),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    Map<String, dynamic> data = {
                      'nama': namaController.text,
                      'username': userController.text,
                      'password': passController.text,
                      'status': userStatus
                    };
                    if (userForm.currentState!.validate()) {
                      if (widget.stat == 'edit') {
                        context
                            .read<UserBloc>()
                            .add(UpdateUser(id: widget.id!, data: data));
                      } else {
                        context.read<UserBloc>().add(TambahUser(data: data));
                      }
                      Fluttertoast.showToast(msg: 'Data Berhasil Disimpan');
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan',
                      style: TextStyle(color: textColorInvert)),
                ))
              ],
            )
          ],
        ));
  }
}

Widget customTextField(
    {bool? obs,
    required String validator,
    required String label,
    required TextEditingController controller}) {
  return TextFormField(
    validator: (value) => (value == null || value.isEmpty) ? validator : null,
    controller: controller,
    cursorColor: primaryColor,
    obscureText: obs ?? false,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: primaryColor),
        ),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: textColor),
        focusColor: primaryColor,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: textColor))),
  );
}
