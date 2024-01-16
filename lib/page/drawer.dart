import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/produk/produk_page.dart';

Widget menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: backgroundcolor,
    child: Column(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'POS Application',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        //const Divider(),

        ListTile(
          trailing: const Icon(
            LineIcons.listOl,
            size: 35,
            color: primaryColor,
          ),
          title: const Text(
            'Produk',
            style: TextStyle(color: textColor, fontSize: 20),
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
        const Divider(
          color: primaryColor,
        ),
        ListTile(
          trailing: const Icon(
            LineIcons.shoppingBasket,
            size: 35,
            color: primaryColor,
          ),
          title: const Text(
            'Transaksi',
            style: TextStyle(color: textColor, fontSize: 20),
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
        const Divider(
          color: primaryColor,
        ),
        const ListTile(
          trailing: Icon(
            LineIcons.fileAlt,
            size: 35,
            color: primaryColor,
          ),
          title: Text(
            'Laporan',
            style: TextStyle(color: textColor, fontSize: 20),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
                color: primaryColor),
            child: const Center(
              child: Text(
                'Log Out',
                style: TextStyle(color: textColorInvert, fontSize: 16),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
