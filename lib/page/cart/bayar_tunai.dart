import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/bloc/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';

class BayarTunai extends StatefulWidget {
  final int totalTransaksi;

  const BayarTunai({super.key, required this.totalTransaksi});

  @override
  State<BayarTunai> createState() => _BayarTunaiState();
}

class _BayarTunaiState extends State<BayarTunai> {
  int bayar = 0;
  int kembali = 0;
  bool isFinish = false;
  @override
  Widget build(BuildContext context) {
    double tinggi = MediaQuery.sizeOf(context).height - 50;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        elevation: 0,
        title: const Text(
          'Bayar Tunai',
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: tinggi * 0.08,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Row(children: [
              const Text(
                'Total',
                style: TextStyle(color: textColorInvert, fontSize: 16),
              ),
              const Spacer(),
              Text(
                formatter.format(widget.totalTransaksi),
                style: const TextStyle(color: textColorInvert, fontSize: 16),
              )
            ]),
          ),
          Expanded(
            child: Container(
              height: tinggi * 0.22,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)
                  //border: Border.all(color: primaryColor),
                  ),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatter.format(bayar),
                    style: const TextStyle(fontSize: 60),
                  )),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(defaultPadding),
              //height: tinggi * 0.6,
              child: numericPad()),
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            height: 90,
            child: Row(children: [
              Expanded(
                  child: Material(
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius)),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      bayar = widget.totalTransaksi;
                    });
                  },
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius))),
                    child: const Center(
                      child: Text(
                        'Uang Pas',
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              )),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                  child: Material(
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius)),
                child: InkWell(
                  onTap: () {
                    DateTime now = DateTime.now();
                    if (bayar < widget.totalTransaksi) {
                      Fluttertoast.showToast(msg: 'Pembayaran Masih Kurang');
                    } else {
                      Map<String, dynamic> data = {
                        'tanggal': now.day,
                        'bulan': now.month,
                        'tahun': now.year,
                        'jam': '${now.hour}:${now.minute}',
                        'an': 'Tunai',
                        'total': widget.totalTransaksi,
                        'status': 'finish',
                        'pembayaran': 'tunai',
                        'bayar': bayar,
                        'kembali': kembali
                      };

                      TransaksiBloc transaksiBloc =
                          BlocProvider.of<TransaksiBloc>(context);
                      transaksiBloc.add(SimpanTransaksi(dataTransaksi: data));
                      setState(() {
                        isFinish = true;
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        CartBloc cart = BlocProvider.of<CartBloc>(context);
                        cart.add(GetCart());
                        Fluttertoast.showToast(msg: 'Transaksi Berhasil');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartPage()),
                        );
                      });
                    }
                  },
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        //border: Border.all(color: primaryColor, width: 2),
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius))),
                    child: Center(
                      child: Builder(builder: (context) {
                        if (isFinish) {
                          return const CircularProgressIndicator(
                            color: textColorInvert,
                          );
                        } else {
                          return const Text(
                            'Bayar',
                            style:
                                TextStyle(color: textColorInvert, fontSize: 16),
                          );
                        }
                      }),
                    ),
                  ),
                ),
              ))
            ]),
          )
        ],
      ),
    );
  }

  Widget numericPad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              buildButton('1'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('2'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('3'),
            ],
          ),
        ),
        const Divider(
          color: primaryColor,
          height: 1,
          thickness: 1,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              buildButton('4'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('5'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('6'),
            ],
          ),
        ),
        const Divider(
          color: primaryColor,
          height: 1,
          thickness: 1,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              buildButton('7'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('8'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('9'),
            ],
          ),
        ),
        const Divider(
          color: primaryColor,
          height: 1,
          thickness: 1,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              const Spacer(),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('0'),
              const VerticalDivider(
                color: primaryColor,
                width: 1,
                thickness: 1,
              ),
              buildButton('⌫', onPressed: backspace, warna: primaryColor),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              nominal(15000, left: defaultRadius),
              const VerticalDivider(
                color: textColorInvert,
                width: 1,
                thickness: 1,
              ),
              nominal(20000),
              const VerticalDivider(
                color: textColorInvert,
                width: 1,
                thickness: 1,
              ),
              nominal(50000, right: defaultRadius),
            ],
          ),
        ),
      ],
    );
  }

  Widget nominal(
    int nominal, {
    double? left,
    double? right,
  }) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Material(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(left ?? 0),
              bottomRight: Radius.circular(right ?? 0)),
          child: InkWell(
            onTap: () {
              int hitung = nominal - widget.totalTransaksi;
              setState(() {
                bayar = nominal;
                kembali = hitung < 0 ? 0 : hitung;
              });
            },
            child: Center(
                child: Text(
              formatter.format(nominal),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColorInvert),
            )),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, {VoidCallback? onPressed, Color? warna}) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Material(
          child: InkWell(
            onTap: onPressed ?? () => input(text),
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: warna ?? textColor),
            )),
          ),
        ),
      ),
    );
  }

  void input(String text) {
    String value = bayar.toString() + text;
    if (value.isNotEmpty) {
      int hitung = int.parse(value) - widget.totalTransaksi;
      setState(() {
        bayar = int.parse(value);
        kembali = hitung < 0 ? 0 : hitung;
      });
    }
  }

  void backspace() {
    String value = bayar.toString();
    String byr = value.substring(0, value.length - 1);
    byr = byr.isEmpty ? '0' : byr;
    if (byr.isNotEmpty) {
      int hitung = int.parse(byr) - widget.totalTransaksi;
      setState(() {
        bayar = int.parse(byr);
        kembali = hitung < 0 ? 0 : hitung;
      });
    }
  }
}
