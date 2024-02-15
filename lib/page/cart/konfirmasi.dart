import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/page/cart/komponen/simpan_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

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
    var containerColor = Theme.of(context).colorScheme.surfaceVariant;
    var teksColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Konfirmasi',
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: const Icon(
                LineIcons.arrowLeft,
              ),
              onPressed: () {
                context.read<CartBloc>().add(GetCart());

                Navigator.pop(context);
              });
        }),
      ),
      body: BlocBuilder<KonfirmasiBloc, KonfirmasiState>(
          builder: (context, state) {
        if (state is KonfirmasiLoading) {
          return const Center(
            child: CircularProgressIndicator(),
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
          return VStack(
            [
              Expanded(
                child: VxBox(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: konfirmasiLoaded.data.cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      return produkTile(
                          idx: index,
                          detailData: konfirmasiLoaded.data.cart[index],
                          context: context);
                    },
                  ),
                ).rounded.color(containerColor).p16.make().p24(),
              ),
              VxBox(
                child: HStack([
                  const Text(
                    'Total',
                  ).text.xl.color(teksColor).bold.make(),
                  const Spacer(),
                  Text(
                    formatter.format(konfirmasiLoaded.data.totalTransaksi),
                  ).text.xl.color(teksColor).bold.make(),
                ]),
              )
                  .rounded
                  .color(containerColor)
                  .p16
                  .make()
                  .pOnly(bottom: 24, left: 24, right: 24),
              HStack([
                Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpanDialog(
                                  totalTransaksi:
                                      konfirmasiLoaded.data.totalTransaksi,
                                );
                              });
                        },
                        icon: const Icon(LineIcons.check),
                        label: const Text('Simpan'))),
              ]).pOnly(left: 24, right: 24, bottom: 16),
              HStack([
                Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LineIcons.doubleCheck),
                        label: const Text('Simpan Dan Bayar')))
              ]).pOnly(left: 24, right: 24, bottom: 24)
            ],
          );
        }
      }),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
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
  return HStack(
    [
      VStack(
        [
          Text(
            detailData.nama,
          ).text.bold.xl.make(),
          HStack(
            [
              CustomIconButton(
                  height: 30,
                  width: 30,
                  icon: LineIcons.minus,
                  fungsi: () {
                    int jml = detailData.jumlah - 1;
                    int ttl = jml * detailData.harga;

                    KonfirmasiBloc cart =
                        BlocProvider.of<KonfirmasiBloc>(context);

                    cart.add(TambahKonfirmasi(
                        status: 'minus',
                        idProduk: detailData.id,
                        harga: detailData.harga,
                        nama: detailData.nama,
                        jumlah: jml,
                        total: ttl,
                        idx: idx));
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: 16,
                  child: Center(
                    child: Text(
                      detailData.jumlah.toString(),
                    ).text.xl.make(),
                  ),
                ),
              ),
              CustomIconButton(
                  height: 30,
                  width: 30,
                  icon: LineIcons.plus,
                  fungsi: () {
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
        spacing: 5,
      ),
      const Spacer(),
      Text(
        formatter.format(detailData.total),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
    spacing: 5,
  );
}

class CustomIconButton extends StatelessWidget {
  final double width;
  final double height;
  final IconData icon;
  final Function()? fungsi;

  const CustomIconButton({
    Key? key,
    required this.width,
    required this.height,
    required this.icon,
    this.fungsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.tertiary,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: fungsi,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        splashColor: Theme.of(context).colorScheme.onTertiary,
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
              child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onTertiary,
            size: 15,
          )),
        ),
      ),
    );
  }
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
