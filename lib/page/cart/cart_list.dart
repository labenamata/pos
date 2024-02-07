import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/cart_model.dart';

var faker = Faker();

class CartList extends StatelessWidget {
  const CartList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoading) {
        return const CircularProgressIndicator();
      } else {
        CartLoaded cartLoaded = state as CartLoaded;
        //Future.delayed(const Duration(seconds: 5), () {});

        return ListView.builder(
          padding: EdgeInsets.zero,
          //shrinkWrap: true,
          itemCount: cartLoaded.data.cart.length,
          itemBuilder: (BuildContext context, int index) {
            return produkTile(
                idx: index,
                detailData: cartLoaded.data.cart[index],
                context: context);
          },
        );
      }
      //   return ListView.separated(
      //     itemCount: 20,
      //     itemBuilder: (BuildContext context, int index) {
      //       return SizedBox(
      //         height: 50,
      //         child: Row(
      //           children: [
      //             SizedBox(
      //               height: 50,
      //               width: 50,
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                     border: Border.all(),
      //                     borderRadius: BorderRadius.circular(defaultRadius)),
      //                 child: ClipRRect(
      //                     borderRadius: BorderRadius.circular(defaultRadius),
      //                     child: Image(
      //                         image: NetworkImage(
      //                             faker.image.image(keywords: ['dish'])))),
      //               ),
      //             ),
      //             const SizedBox(
      //               width: 10,
      //             ),
      //             Column(
      //                 //mainAxisSize: MainAxisSize.min,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     faker.food.dish(),
      //                     style: TextStyle(
      //                         fontSize: 12,
      //                         fontWeight: FontWeight.bold,
      //                         color: Theme.of(context)
      //                             .colorScheme
      //                             .onPrimaryContainer),
      //                     overflow: TextOverflow.ellipsis,
      //                   ),
      //                   const Spacer(),
      //                   Text(
      //                     formatter.format(random.integer(100000, min: 1000)),
      //                     style: TextStyle(
      //                         fontSize: 12,
      //                         color: Theme.of(context)
      //                             .colorScheme
      //                             .onPrimaryContainer),
      //                   ),
      //                 ]),
      //           ],
      //         ),
      //       );
      //     },
      //     separatorBuilder: (BuildContext context, int index) {
      //       return const SizedBox(
      //         height: defaultPadding,
      //       );
      //     },
      //   );
      // }

      //
    });
  }
}

Widget produkTile(
    {required int idx,
    required ListCart detailData,
    required BuildContext context}) {
  return Card(
    shadowColor: Colors.transparent,
    child: SizedBox(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(defaultRadius)),
              child: Image.memory(
                detailData.image,
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailData.nama,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    formatter.format(detailData.harga),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Stok : ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Row(
                      children: [
                        Material(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          color: Theme.of(context).colorScheme.primary,
                          child: InkWell(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              onTap: () {
                                int jml = detailData.jumlah - 1;
                                int ttl = jml * detailData.harga;

                                CartBloc cart =
                                    BlocProvider.of<CartBloc>(context);

                                cart.add(TambahCart(
                                    status: 'minus',
                                    idProduk: detailData.id,
                                    harga: detailData.harga,
                                    nama: detailData.nama,
                                    jumlah: jml > 0 ? jml : 0,
                                    total: jml > 0 ? ttl : 0,
                                    idx: idx));
                              },
                              // ignore: prefer_const_constructors
                              child: SizedBox(
                                width: 40,
                                height: 30,
                                child: Icon(
                                  LineIcons.minus,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  //color: Colors.white,
                                ),
                              )),
                        ),
                        const Spacer(),
                        Text(
                          detailData.jumlah.toString(),
                          //style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Material(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: Theme.of(context).colorScheme.primary,
                          child: InkWell(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              onTap: () {
                                int jml = detailData.jumlah + 1;
                                int ttl = jml * detailData.harga;

                                CartBloc cart =
                                    BlocProvider.of<CartBloc>(context);
                                cart.add(TambahCart(
                                    status: 'plus',
                                    idProduk: detailData.id,
                                    harga: detailData.harga,
                                    nama: detailData.nama,
                                    jumlah: jml,
                                    total: ttl,
                                    idx: idx));
                              },
                              // ignore: prefer_const_constructors
                              child: SizedBox(
                                width: 40,
                                height: 30,
                                child: Icon(
                                  LineIcons.plus,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //           color: Theme.of(context).colorScheme.primary,
  //           borderRadius: BorderRadius.circular(defaultRadius)),
  //     ),

  //     SizedBox(
  //       height: 90,
  //       width: 200,
  //       child: Container(
  //         decoration: BoxDecoration(
  //             //border: Border.all(),
  //             borderRadius: BorderRadius.circular(defaultRadius)),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(defaultRadius),
  //           child: Image.memory(
  //             detailData.image,
  //             height: 100,
  //             width: 200,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //     ),
  //     Text(detailData.nama),
  // const SizedBox(
  //   width: 10,
  // ),
  // Column(
  //     //mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         detailData.nama,
  //         style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.bold,
  //             color: Theme.of(context).colorScheme.onPrimaryContainer),
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       const Spacer(),
  //       Text(
  //         formatter.format(detailData.harga),
  //         style: TextStyle(
  //             fontSize: 12,
  //             color: Theme.of(context).colorScheme.onPrimaryContainer),
  //       ),
  //     ]),
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
}
