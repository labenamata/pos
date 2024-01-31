import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/bloc/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/page/report/laporan.dart';

var faker = Faker();
Widget menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: backgroundcolor,
    child: Column(
      children: [
        UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage(faker.image.image(keywords: ['person']))),
            accountName: Text(
              faker.address.person.name(),
              style: const TextStyle(color: textColorInvert),
            ),
            accountEmail: Text(
              faker.internet.email(),
              style: const TextStyle(color: textColorInvert),
            )),
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
            CartBloc cart = BlocProvider.of<CartBloc>(context);
            cart.add(EmptyCart());
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              textStyle: const TextStyle(color: Colors.white)),
          onPressed: () {},
          child: const Text(
            'Log Out',
            style: TextStyle(color: textColorInvert, fontSize: 12),
          ),
        )
      ],
    ),
  );
}
