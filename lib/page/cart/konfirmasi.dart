import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/konfirmasi/konfirmasi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/cart_model.dart';
import 'package:pos_app/page/cart/bayar_non.dart';
import 'package:pos_app/page/cart/bayar_tunai.dart';

class Konfirmasi extends StatelessWidget {
  const Konfirmasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Text('Bayar'),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: textColorInvert,
          backgroundColor: primaryColor,
          //shape: const CircleBorder(),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                LineIcons.timesCircleAlt,
                color: primaryColor,
                size: 40,
              ),
            );
          },
        ),
        children: [
          navButton(
              fungsi: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BayarTunai()),
                  ),
              icon: LineIcons.moneyBill,
              label: 'Tunai',
              warna: Colors.green),
          navButton(
              fungsi: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BayarNon()),
                  ),
              icon: LineIcons.simCard,
              label: 'Non Tunai',
              warna: Colors.orange),
          navButton(
              icon: LineIcons.shoppingBag, label: 'Nanti', warna: primaryColor),
        ],
      ),
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        elevation: 0,
        title: const Text(
          'Konfirmasi',
          style: TextStyle(color: textColor),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(
                LineIcons.angleLeft,
                color: textColor,
              ),
              onPressed: () {
                CartBloc cart = BlocProvider.of<CartBloc>(context);
                cart.add(GetCart());
                Navigator.pop(context);
              });
        }),
      ),
      body: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: BlocBuilder<KonfirmasiBloc, KonfirmasiState>(
              builder: (context, state) {
            if (state is KonfirmasiLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            KonfirmasiLoaded konfirmasiLoaded = state as KonfirmasiLoaded;
            if (konfirmasiLoaded.data.totalTransaksi == 0) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      LineIcons.excelFile,
                      size: 100,
                    ),
                    Text('Belum Ada Transaksi')
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Container(
                    height: 80,
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius))),
                    child: Row(children: [
                      const Text(
                        'Total',
                        style: TextStyle(color: textColorInvert, fontSize: 20),
                      ),
                      const Spacer(),
                      Text(
                        formatter.format(konfirmasiLoaded.data.totalTransaksi),
                        style: const TextStyle(
                            color: textColorInvert, fontSize: 20),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: primaryColor,
                          thickness: 2,
                        );
                      },
                      itemCount: konfirmasiLoaded.data.cart.length,
                      itemBuilder: (BuildContext context, int index) {
                        return produkTile(
                            idx: index,
                            detailData: konfirmasiLoaded.data.cart[index],
                            context: context);
                      },
                    ),
                  ),
                ],
              );
            }
          })),
    );
  }
}

Widget navButton(
    {IconData? icon, String? label, Function()? fungsi, Color? warna}) {
  return Material(
    color: warna,
    borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
    child: InkWell(
        onTap: fungsi,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(contentPadding),
          //decoration: const BoxDecoration(borderRadius: rad),
          child: Row(children: [
            Icon(
              icon,
              size: 20,
              color: textColorInvert,
            ),
            const VerticalDivider(
              color: textColorInvert,
            ),
            // const SizedBox(
            //   width: contentPadding,
            // ),
            Text(
              label!,
              style: const TextStyle(
                fontSize: 14,
                color: textColorInvert,
              ),
            )
          ]),
        )),
  );
}

Widget produkTile(
    {required int idx,
    required ListCart detailData,
    required BuildContext context}) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detailData.nama,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                  //style: IconButton.styleFrom(backgroundColor: primaryColor),
                  //constraints: BoxConstraints(maxHeight: 36),
                  icon: const Icon(
                    LineIcons.minusCircle,
                    size: 30,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    int jml = detailData.jumlah - 1;
                    int ttl = jml * detailData.harga;

                    KonfirmasiBloc cart =
                        BlocProvider.of<KonfirmasiBloc>(context);

                    // if (jml <= 0) {
                    //   cart.add(HapusCart(id: detailData.id));
                    // }

                    cart.add(TambahKonfirmasi(
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
                // decoration: const BoxDecoration(
                //     color: primaryColor,
                //     borderRadius:
                //         BorderRadius.all(Radius.circular(defaultRadius))),
                child: SizedBox(
                  width: 16,
                  child: Center(
                    child: Text(
                      detailData.jumlah.toString(),
                      style: const TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                ),
              ),
              IconButton(
                  // splashRadius: 20,
                  // constraints: const BoxConstraints(maxHeight: 20),
                  // style:
                  //     ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  icon: const Icon(
                    LineIcons.plusCircle,
                    color: primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    int jml = detailData.jumlah + 1;
                    int ttl = jml * detailData.harga;

                    KonfirmasiBloc cart =
                        BlocProvider.of<KonfirmasiBloc>(context);
                    cart.add(TambahKonfirmasi(
                        status: 'plus',
                        idProduk: detailData.id,
                        harga: detailData.harga,
                        nama: detailData.nama,
                        jumlah: jml,
                        total: ttl,
                        idx: idx));
                  }),
            ],
          ),
        ],
      ),
      const Spacer(),
      Text(
        formatter.format(detailData.total),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Future<void> bayarTunai({required BuildContext context, required int total}) {
  int bayar = 0;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(defaultRadius))),
                  child: Row(children: [
                    const Text(
                      'Total',
                      style: TextStyle(color: textColorInvert, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      formatter.format(total),
                      style:
                          const TextStyle(color: textColorInvert, fontSize: 16),
                    )
                  ]),
                ),
                const SizedBox(
                  height: contentPadding,
                ),
                Row(
                  children: [
                    const Text(
                      'Bayar',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: contentPadding,
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(defaultRadius))),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formatter.format(bayar),
                              style: const TextStyle(fontSize: 16),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}
