import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/konfirmasi/konfirmasi_bloc.dart';
import 'package:pos_app/page/cart/cart_list.dart';
import 'package:pos_app/page/cart/konfirmasi.dart';
import 'package:pos_app/widget/kategori_filter.dart';
import 'package:pos_app/widget/search_menu.dart';

var faker = Faker();

class CartPage extends StatefulWidget {
  final String stat;
  final int? idTransaksi;
  final String? nama;
  const CartPage({
    Key? key,
    required this.stat,
    this.idTransaksi,
    this.nama,
  }) : super(key: key);

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
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: floatingConfirm(),
              )
            ],
            title:
                Text(widget.stat == 'baru' ? 'Transaksi Baru' : widget.nama!)),
        body: ColorfulSafeArea(
          color: Theme.of(context).colorScheme.tertiary,
          child: VStack(
            [
              SearchMenu(
                  searchController: searchController,
                  fungsi: (val) {
                    context
                        .read<CartBloc>()
                        .add(GetCart(nama: searchController.text));
                  }),
              const KategoriFilter(
                page: 'cart',
              ),
              const Expanded(child: CartList())
            ],
          ),
        ));
  }
}

Widget floatingConfirm() {
  return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
    if (state is CartLoaded) {
      CartLoaded cartLoaded = state;
      if (cartLoaded.data.totalTransaksi != 0) {
        return Row(children: [
          CustomButton(
              child: Icon(
                LineIcons.trash,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              function: () {
                context.read<CartBloc>().add(EmptyCart());
              }),
          const SizedBox(
            width: Vx.dp12,
          ),
          CustomButton(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    LineIcons.check,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 30,
                  ),
                ],
              ),
              function: () {
                context
                    .read<KonfirmasiBloc>()
                    .add(GetKonfirmasi(join: 'right'));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Konfirmasi()),
                );
              })
          // IconButton(
          //   onPressed: () {
          //     context.read<CartBloc>().add(EmptyCart());
          //   },
          //   icon: const Icon(
          //     LineIcons.trash,
          //   ),
          // ),
        ]);
      }
    }
    return Container();
  });
}

class CustomButton extends StatelessWidget {
  final Widget child;
  final Function()? function;
  const CustomButton({
    Key? key,
    required this.child,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.onTertiary,
        onTap: function,
        child: SizedBox(
          height: double.infinity,
          width: 50,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      ),
    );
  }
}
