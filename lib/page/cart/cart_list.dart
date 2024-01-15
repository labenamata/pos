import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/cart_model.dart';

class CartList extends StatelessWidget {
  const CartList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      } else {
        CartLoaded cartLoaded = state as CartLoaded;

        return ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(
              color: primaryColor,
              thickness: 1,
            );
          },
          itemCount: cartLoaded.data.cart.length,
          itemBuilder: (BuildContext context, int index) {
            return produkTile(
                idx: index,
                detailData: cartLoaded.data.cart[index],
                context: context);
          },
        );
      }

      //
    });
  }
}

Widget produkTile(
    {required int idx,
    required ListCart detailData,
    required BuildContext context}) {
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: Image.memory(
          detailData.image,
          height: 80.0,
          width: 80.0,
        ),
      ),
      const SizedBox(
        width: contentPadding,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detailData.nama,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            formatter.format(detailData.harga),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
      const Spacer(),
      IconButton(
          splashRadius: 24.0,
          //constraints: BoxConstraints(maxHeight: 36),
          icon: const Icon(
            LineIcons.minus,
            color: primaryColor,
          ),
          onPressed: () {
            int jml = detailData.jumlah - 1;
            int ttl = jml * detailData.harga;

            CartBloc cart = BlocProvider.of<CartBloc>(context);

            cart.add(TambahCart(
                status: 'minus',
                idProduk: detailData.id,
                harga: detailData.harga,
                nama: detailData.nama,
                jumlah: jml,
                total: ttl,
                idx: idx));
          }),
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        child: SizedBox(
          width: 16,
          child: Center(
            child: Text(
              detailData.jumlah.toString(),
              style: const TextStyle(fontSize: 16, color: textColorInvert),
            ),
          ),
        ),
      ),
      IconButton(
          splashRadius: 24.0,

          //constraints: BoxConstraints(maxHeight: 36),
          icon: const Icon(
            LineIcons.plus,
            color: primaryColor,
          ),
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
          }),
    ],
  );
}
