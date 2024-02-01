import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //childAspectRatio: 1 / 2,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: cartLoaded.data.cart.length > 10
              ? cartLoaded.data.cart.length
              : 10,
          itemBuilder: (BuildContext context, int index) {
            if (index + 1 <= cartLoaded.data.cart.length) {
              return produkTile(
                  idx: index,
                  detailData: cartLoaded.data.cart[index],
                  context: context);
            } else {
              return Container(
                decoration: const BoxDecoration(
                    color: textColorInvert,
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultRadius))),
              );
            }
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
    decoration: const BoxDecoration(
        //border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
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
        Builder(builder: (BuildContext context) {
          if (detailData.jumlah > 0) {
            return Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: backgroundcolor, width: 2),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(defaultRadius),
                          topRight: Radius.circular(defaultRadius))),
                  child: Center(
                    child: Text(
                      detailData.jumlah.toString(),
                      style:
                          const TextStyle(color: textColorInvert, fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox(
              height: 20,
              width: 20,
            );
          }
        }),

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
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(defaultRadius),
                    bottomRight: Radius.circular(defaultRadius))),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detailData.nama,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColorInvert),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatter.format(detailData.harga),
                        style: const TextStyle(
                            fontSize: 14, color: textColorInvert),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Builder(builder: (BuildContext context) {
                  if (detailData.jumlah > 0) {
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                          child: Icon(
                        LineIcons.minusCircle,
                        color: textColorInvert,
                      )),
                    );
                  } else {
                    return const SizedBox(
                      height: 20,
                      width: 20,
                    );
                  }
                })
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
