import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/bloc/konfirmasi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_list.dart';
import 'package:pos_app/page/cart/kategori_cart.dart';
import 'package:pos_app/page/cart/konfirmasi.dart';
import 'package:pos_app/page/cart/search_produk_cart.dart';
import 'package:pos_app/page/drawer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      drawer: menuDrawer(context),
      floatingActionButton: floatingConfirm(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundcolor,
        title: const Text(
          'Transaksi Baru',
          style: TextStyle(color: textColor),
        ),
        leading:
            // Ensure Scaffold is in context
            Builder(builder: (context) {
          return IconButton(
              icon: const Icon(
                LineIcons.bars,
                color: textColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(children: [
          searchProdukCart(context),
          const SizedBox(
            height: defaultPadding,
          ),
          const KategoriCart(),
          const SizedBox(
            height: defaultPadding,
          ),
          const Expanded(child: CartList())
        ]),
      ),
    );
  }
}

Widget floatingConfirm() {
  return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
    if (state is CartLoaded) {
      CartLoaded cartLoaded = state;
      if (cartLoaded.data.totalTransaksi != 0) {
        return FloatingActionButton.extended(
            icon: const Icon(LineIcons.check),
            backgroundColor: primaryColor,
            label: Text(
              formatter.format(cartLoaded.data.totalTransaksi),
              style: const TextStyle(color: textColorInvert, fontSize: 20),
            ),
            onPressed: () {
              KonfirmasiBloc cart = BlocProvider.of<KonfirmasiBloc>(context);
              cart.add(GetKonfirmasi(join: 'right'));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Konfirmasi()),
              );
            });
      }
    }
    return Container();
  });
}
