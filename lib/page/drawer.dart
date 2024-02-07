import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/login/login_bloc.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/bloc/user/user_bloc.dart';
import 'package:pos_app/main.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/login/login_page.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/page/report/laporan.dart';
import 'package:pos_app/page/user/user_page.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      //backgroundColor: backgroundcolor,
      children: [
        // BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        //   LoginState info = state;
        //   return UserAccountsDrawerHeader(
        //       currentAccountPicture: const CircleAvatar(
        //         child: Icon(
        //           LineIcons.user,
        //           size: 50,
        //         ),
        //       ),
        //       accountName: Text(
        //         info.nama,
        //       ),
        //       accountEmail: Text(
        //         info.status,
        //       ));
        // }),
        // Row(
        //   children: [
        //     const Text('Dark Mode'),
        //     const Spacer(),
        //     Switch(
        //       value: _value,
        //       onChanged: (value) {
        //         setState(() {
        //           _value = value;
        //           if (_value) {
        //             MyApp.of(context)!.changeTheme(ThemeMode.dark);
        //           } else {
        //             MyApp.of(context)!.changeTheme(ThemeMode.light);
        //           }
        //         });
        //       },
        //     ),
        //   ],
        // ),

        ListTile(
          leading: const Icon(
            LineIcons.listOl,
            size: 30,
          ),
          title: const Text(
            'Produk',
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProdukPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            LineIcons.shoppingCart,
            size: 30,
          ),
          title: const Text(
            'Transaksi',
          ),
          onTap: () {
            context.read<CartBloc>().add(EmptyCart());
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
        ),
        ListTile(
          onTap: () {
            int tanggal = DateTime.now().day;
            int bulan = DateTime.now().month;
            int tahun = DateTime.now().year;

            context.read<TransaksiBloc>().add(GetTransaksi(
                status: 'finish',
                tanggal: tanggal,
                bulan: bulan,
                tahun: tahun));

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LaporanPage()),
            );
          },
          leading: const Icon(
            LineIcons.fileAlt,
            size: 30,
            //color: primaryColor,
          ),
          title: const Text(
            'Laporan',
            //style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
        ListTile(
          onTap: () {
            context.read<UserBloc>().add(GetUser());
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserPage()),
            );
          },
          leading: const Icon(
            LineIcons.userCircle,
            size: 30,
            //color: primaryColor,
          ),
          title: const Text(
            'User',
            //style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
        // const Spacer(),
        TextButton(
          onPressed: () {
            context.read<LoginBloc>().add(Logout());

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Log Out',
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    );
  }
}
