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

        return GridView.builder(
          // separatorBuilder: (context, index) {
          //   return const Divider(
          //     color: primaryColor,
          //     thickness: 1,
          //   );
          // },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
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
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(defaultRadius))),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: () {
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(defaultRadius),
            child: Image.memory(
              detailData.image,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 50,
            width: 50,
            child: Container(
              decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(defaultRadius),
                      topRight: Radius.circular(defaultRadius))),
              child: Center(
                child: Text(
                  detailData.jumlah.toString(),
                  style: const TextStyle(color: textColorInvert, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
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
          },
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 40,
              width: 40,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(defaultRadius),
                        topLeft: Radius.circular(defaultRadius))),
                child: const Center(
                    child: Icon(
                  LineIcons.minus,
                  color: textColorInvert,
                )),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
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
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailData.nama,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  formatter.format(detailData.harga),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        // IconButton(
        //     splashRadius: 24.0,
        //     //constraints: BoxConstraints(maxHeight: 36),
        //     icon: const Icon(
        //       LineIcons.minus,
        //       color: primaryColor,
        //     ),
        //     onPressed: () {
        //       int jml = detailData.jumlah - 1;
        //       int ttl = jml * detailData.harga;

        //       CartBloc cart = BlocProvider.of<CartBloc>(context);

        //       cart.add(TambahCart(
        //           status: 'minus',
        //           idProduk: detailData.id,
        //           harga: detailData.harga,
        //           nama: detailData.nama,
        //           jumlah: jml,
        //           total: ttl,
        //           idx: idx));
        //     }),
        // Container(
        //   padding: const EdgeInsets.all(defaultPadding),
        //   decoration: const BoxDecoration(
        //       color: primaryColor,
        //       borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        //   child: SizedBox(
        //     width: 16,
        //     child: Center(
        //       child: Text(
        //         detailData.jumlah.toString(),
        //         style: const TextStyle(fontSize: 16, color: textColorInvert),
        //       ),
        //     ),
        //   ),
        // ),
        // IconButton(
        //     splashRadius: 24.0,

        //     //constraints: BoxConstraints(maxHeight: 36),
        //     icon: const Icon(
        //       LineIcons.plus,
        //       color: primaryColor,
        //     ),
        //     onPressed: () {
        //       int jml = detailData.jumlah + 1;
        //       int ttl = jml * detailData.harga;

        //       CartBloc cart = BlocProvider.of<CartBloc>(context);
        //       cart.add(TambahCart(
        //           status: 'plus',
        //           idProduk: detailData.id,
        //           harga: detailData.harga,
        //           nama: detailData.nama,
        //           jumlah: jml,
        //           total: ttl,
        //           idx: idx));
        //     }),
      ],
    ),
  );
}
