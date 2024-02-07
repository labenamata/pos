import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/konfirmasi/konfirmasi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_list.dart';
import 'package:pos_app/page/cart/konfirmasi.dart';
import 'package:pos_app/widget/search_menu.dart';
import 'package:pos_app/page/drawer.dart';
import 'package:pos_app/widget/kategori_filter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          drawer: const SideMenu(),
          floatingActionButton: floatingConfirm(),
          appBar: AppBar(
            title: const Text('Transaksi Baru'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                SearchMenu(
                    searchController: searchController,
                    fungsi: (val) {
                      context
                          .read<CartBloc>()
                          .add(GetCart(nama: searchController.text));
                    }),
                const SizedBox(
                  height: defaultPadding,
                ),
                const KategoriFilter(
                  page: 'cart',
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Expanded(child: CartList())
              ],
            ),
          )),
    );
  }
}

Widget floatingConfirm() {
  return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
    if (state is CartLoaded) {
      CartLoaded cartLoaded = state;
      if (cartLoaded.data.totalTransaksi != 0) {
        return FloatingActionButton.extended(
            icon: const Icon(
              LineIcons.check,
            ),
            label: Text(
              formatter.format(cartLoaded.data.totalTransaksi),
              style: const TextStyle(fontSize: 20),
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
