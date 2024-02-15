import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/cart_model.dart';

var faker = Faker();

class CartList extends StatelessWidget {
  const CartList({super.key});
  @override
  Widget build(BuildContext context) {
    var capsuleColor = Theme.of(context).colorScheme.surfaceVariant;
    var capsuleTextColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoading) {
        return const CircularProgressIndicator();
      } else {
        CartLoaded cartLoaded = state as CartLoaded;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 5,
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24),
            padding: EdgeInsets.zero,
            itemCount: cartLoaded.data.cart.length,
            itemBuilder: (BuildContext context, int index) {
              return produkTile(
                  containerColor: capsuleColor,
                  teksColor: capsuleTextColor,
                  idx: index,
                  detailData: cartLoaded.data.cart[index],
                  context: context);
            },
          ),
        );
      }
    });
  }
}

Widget produkTile(
    {required int idx,
    required ListCart detailData,
    required BuildContext context,
    required Color containerColor,
    required Color teksColor}) {
  return VxBox(
    child: VStack(
      [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
          child: Image.memory(
            detailData.image,
            height: 140,
            width: 140,
          ),
        ),
        const SizedBox(
          height: Vx.dp6,
        ),
        Text(
          detailData.nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${formatter.format(detailData.harga)} ',
        ).text.color(teksColor).make(),
        const Spacer(),
        detailData.jumlah == 0
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () {
                          int jml = detailData.jumlah + 1;
                          int ttl = jml * detailData.harga;

                          CartBloc cart = BlocProvider.of<CartBloc>(context);
                          cart.add(TambahCart(
                              status: 'plus',
                              idProduk: detailData.id,
                              harga: detailData.harga,
                              nama: detailData.nama,
                              jumlah: jml,
                              total: ttl,
                              idx: idx));
                        },
                        icon: const Icon(LineIcons.addToShoppingCart),
                        label: const Text('Tambah')),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                      child: TambahJumlah(
                    idx: idx,
                    detailData: detailData,
                  ))
                ],
              )
      ],
    ).p12(),
  ).rounded.color(containerColor).make();
}

class TambahJumlah extends StatelessWidget {
  final ListCart detailData;
  final int idx;
  const TambahJumlah({
    Key? key,
    required this.detailData,
    required this.idx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var containerColor = Theme.of(context).colorScheme.tertiary;
    var teksColor = Theme.of(context).colorScheme.onTertiary;
    return HStack([
      IconButton(
          onPressed: () {
            int jml = detailData.jumlah - 1;
            int ttl = jml * detailData.harga;

            CartBloc cart = BlocProvider.of<CartBloc>(context);

            cart.add(TambahCart(
                status: 'minus',
                idProduk: detailData.id,
                harga: detailData.harga,
                nama: detailData.nama,
                jumlah: jml > 0 ? jml : 0,
                total: jml > 0 ? ttl : 0,
                idx: idx));
          },
          icon: const Icon(LineIcons.minus)),
      Expanded(
          child: VxBox(
        child: Text(
          detailData.jumlah.toString(),
          textAlign: TextAlign.center,
        ).text.xl.color(teksColor).bold.center.make(),
      ).color(containerColor).roundedFull.p8.make()),
      IconButton(
          onPressed: () {
            int jml = detailData.jumlah + 1;
            int ttl = jml * detailData.harga;

            CartBloc cart = BlocProvider.of<CartBloc>(context);
            cart.add(TambahCart(
                status: 'plus',
                idProduk: detailData.id,
                harga: detailData.harga,
                nama: detailData.nama,
                jumlah: jml,
                total: ttl,
                idx: idx));
          },
          icon: const Icon(LineIcons.plus)),
    ]);
  }
}
