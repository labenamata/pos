import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/user/user_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/user/komponen/form_user.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        UserLoaded userLoaded = state as UserLoaded;
        return ListView.separated(
          itemCount: userLoaded.data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(
                LineIcons.user,
                color: primaryColor,
              ),
              title: Text(userLoaded.data[index].nama),
              subtitle: Text(userLoaded.data[index].status),
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: FormUser(
                                stat: 'edit',
                                id: userLoaded.data[index].id,
                                nama: userLoaded.data[index].nama,
                                username: userLoaded.data[index].username,
                                password: userLoaded.data[index].password,
                                stUser: userLoaded.data[index].status,
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(LineIcons.editAlt)),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: primaryColor,
            );
          },
        );
      }
    });
  }
}
