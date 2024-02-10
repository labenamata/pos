import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/konfirmasi/konfirmasi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_list.dart';
import 'package:pos_app/page/cart/konfirmasi.dart';
import 'package:pos_app/widget/navigation_bar.dart';
import 'package:pos_app/widget/search_menu.dart';

import 'package:pos_app/widget/kategori_filter.dart';

var faker = Faker();

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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: floatingConfirm(),
              )
            ],
            title: Row(children: [
              const Icon(LineIcons.userAlt),
              const SizedBox(
                width: 10,
              ),
              Text(faker.address.person.firstName())
            ]),
          ),
          bottomNavigationBar: const NavMenu(
            pageIndex: 2,
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
        return Row(
          children: [
            IconButton.filled(
              onPressed: () {
                context.read<CartBloc>().add(EmptyCart());
              },
              icon: const Icon(
                LineIcons.trash,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            FilledButton.icon(
                icon: const Icon(
                  LineIcons.check,
                ),
                label: Text(
                  formatter.format(cartLoaded.data.totalTransaksi),
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  KonfirmasiBloc cart =
                      BlocProvider.of<KonfirmasiBloc>(context);
                  cart.add(GetKonfirmasi(join: 'right'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Konfirmasi()),
                  );
                }),
          ],
        );
      }
    }
    return FilledButton.icon(
      icon: const Icon(LineIcons.shoppingCart),
      onPressed: null,
      label: const Text('0'),
    );
  });
}
