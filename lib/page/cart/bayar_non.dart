import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/bloc/konfirmasi_bloc.dart';
import 'package:pos_app/bloc/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';

const List<String> list = <String>['Qris', 'Gopay', 'Dana', 'Kartu', 'Lainnya'];

class BayarNon extends StatefulWidget {
  const BayarNon({super.key});

  @override
  State<BayarNon> createState() => _BayarNonState();
}

class _BayarNonState extends State<BayarNon> {
  TextEditingController anController = TextEditingController();
  late FocusNode an;

  String dropdownValue = list.first;
  int totalTransaksi = 0;

  @override
  void initState() {
    super.initState();
    an = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(LineIcons.angleLeft),
        ),
        title: const Text('Pembayaran Non Tunai'),
        centerTitle: true,
      ),
      body: Column(children: [
        SizedBox(
          height: 50,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              color: primaryColor,
              child: BlocBuilder<KonfirmasiBloc, KonfirmasiState>(
                  builder: (context, state) {
                if (state is KonfirmasiLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }
                KonfirmasiLoaded konfirmasiLoaded = state as KonfirmasiLoaded;
                totalTransaksi = konfirmasiLoaded.data.totalTransaksi;
                return Row(children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: textColorInvert, fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    formatter.format(konfirmasiLoaded.data.totalTransaksi),
                    style:
                        const TextStyle(color: textColorInvert, fontSize: 16),
                  )
                ]);
              })),
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(children: [
            TextField(
              focusNode: an,
              controller: anController,
              decoration: const InputDecoration(
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  prefixIcon: Text('Atas Nama : ')),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Row(children: [
                const Text('Metode : '),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(LineIcons.angleDown),
                    elevation: 16,
                    style: const TextStyle(color: textColor),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: primaryColor, width: 2)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: textColor),
                  ),
                )),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    DateTime now = DateTime.now();
                    if (anController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Mohon Isi Atas Nama');
                      an.requestFocus();
                    } else {
                      Map<String, dynamic> data = {
                        'tanggal': now.day,
                        'bulan': now.month,
                        'tahun': now.year,
                        'jam': '${now.hour}:${now.minute}',
                        'an': anController.text,
                        'total': totalTransaksi,
                        'status': 'finish',
                        'pembayaran': dropdownValue,
                        'bayar': totalTransaksi,
                        'kembali': 0
                      };

                      TransaksiBloc transaksiBloc =
                          BlocProvider.of<TransaksiBloc>(context);
                      transaksiBloc.add(SimpanTransaksi(dataTransaksi: data));

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
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: textColorInvert),
                  ),
                ))
              ],
            )
          ]),
        )
      ]),
    );
  }
}
