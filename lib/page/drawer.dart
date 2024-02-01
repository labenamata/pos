import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/login/login_bloc.dart';
import 'package:pos_app/bloc/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/login/login_page.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/page/report/laporan.dart';

var faker = Faker();
Widget menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: backgroundcolor,
    child: Column(
      children: [
        BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          LoginState info = state;

          return UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: primaryColor),
              currentAccountPicture: const CircleAvatar(
                child: Icon(
                  LineIcons.user,
                  color: textColorInvert,
                  size: 50,
                ),
              ),
              accountName: Text(
                info.nama,
                style: const TextStyle(color: textColorInvert),
              ),
              accountEmail: Text(
                info.status,
                style: const TextStyle(color: textColorInvert),
              ));
        }),
        ListTile(
          leading: const Icon(
            LineIcons.listOl,
            size: 30,
            color: primaryColor,
          ),
          title: const Text(
            'Produk',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProdukPage()),
            );
            //Scaffold.of(context).closeEndDrawer();
          },
        ),
        ListTile(
          leading: const Icon(
            LineIcons.shoppingCart,
            size: 30,
            color: primaryColor,
          ),
          title: const Text(
            'Transaksi',
            style: TextStyle(color: textColor, fontSize: 14),
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
            TransaksiBloc transaksi = BlocProvider.of<TransaksiBloc>(context);
            transaksi.add(GetTransaksi(
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
            color: primaryColor,
          ),
          title: const Text(
            'Laporan',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              textStyle: const TextStyle(color: Colors.white)),
          onPressed: () {
            context.read<LoginBloc>().add(Logout());
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
          },
          child: const Text(
            'Log Out',
            style: TextStyle(color: textColorInvert, fontSize: 12),
          ),
        )
      ],
    ),
  );
}
