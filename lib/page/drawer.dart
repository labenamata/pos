import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/produk/produk_page.dart';

Widget menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: backgroundcolor,
    child: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: Text(
            'POS Application',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        //const Divider(),
        const ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.account_tree_rounded,
          ),
          title: Text(
            'Kategori',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
        const Divider(
          color: primaryColor,
        ),
        ListTile(
          leading: const Icon(
            Icons.apps_rounded,
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
        const ListTile(
          leading: Icon(
            Icons.abc,
          ),
          title: Text(
            'Bahan Baku',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.shopping_bag_rounded,
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
        const ListTile(
          leading: Icon(
            Icons.document_scanner_rounded,
          ),
          title: Text(
            'Laporan',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
