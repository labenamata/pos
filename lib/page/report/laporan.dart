import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Laporan Penjualan',
          style: TextStyle(color: textColor),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(
                LineIcons.angleLeft,
                color: textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              });
        }),
      ),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // BlocBuilder<TransaksiBloc, TransaksiState>(builder: (context, state) {
            //   if (state is TransaksiLoading) {
            //     return Container(
            //         height: 80,
            //         padding: const EdgeInsets.all(defaultPadding),
            //         child: const Center(
            //           child: CircularProgressIndicator(color: primaryColor),
            //         ));
            //   } else {
            //     TransaksiLoaded transaksiLoaded = state as TransaksiLoaded;
            //     return Container(
            //       height: 80,
            //       padding: const EdgeInsets.all(defaultPadding),
            //       decoration: const BoxDecoration(
            //           color: primaryColor,
            //           borderRadius:
            //               BorderRadius.all(Radius.circular(defaultRadius))),
            //       child: Row(children: [
            //         const Text(
            //           'Total',
            //           style: TextStyle(color: textColorInvert, fontSize: 20),
            //         ),
            //         const Spacer(),
            //         Text(
            //           formatter.format(transaksiLoaded.data.),
            //           style:
            //               const TextStyle(color: textColorInvert, fontSize: 20),
            //         ),
            //       ]),
            //     );
            //   }
            // })
            Expanded(child: BlocBuilder<TransaksiBloc, TransaksiState>(
                builder: (context, state) {
              if (state is TransaksiLoading) {
                return Container(
                    height: 80,
                    padding: const EdgeInsets.all(defaultPadding),
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ));
              } else {
                TransaksiLoaded transaksiLoaded = state as TransaksiLoaded;

                return ListView.builder(
                  itemCount: transaksiLoaded.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Expanded(
                            child: Text(
                                transaksiLoaded.data[index].id.toString())),
                        Expanded(child: Text(transaksiLoaded.data[index].an)),
                        Expanded(
                            child: Text(
                          transaksiLoaded.data[index].jam,
                          textAlign: TextAlign.right,
                        )),
                        Expanded(
                            child: Text(
                                formatter.format(
                                  transaksiLoaded.data[index].total,
                                ),
                                textAlign: TextAlign.right))
                      ],
                    );
                  },
                );
              }
            }))
          ],
        ),
      ),
    );
  }
}
