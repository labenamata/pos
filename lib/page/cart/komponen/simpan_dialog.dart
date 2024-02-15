import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/page/transaksi/transaksi_page.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:pos_app/widget/form_field.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController namaController = TextEditingController();
TextEditingController mejaController = TextEditingController();

class SimpanDialog extends StatelessWidget {
  final int totalTransaksi;
  const SimpanDialog({
    Key? key,
    required this.totalTransaksi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: VStack([
              CustomFormField(
                  validator: 'Masukan Nama',
                  label: 'Atas Nama',
                  controller: namaController),
              CustomFormField(
                  validator: 'Masukan No Meja',
                  label: 'Meja No',
                  controller: mejaController),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        if (formKey.currentState!.validate()) {
                          Map<String, dynamic> data = {
                            'tanggal': now.day,
                            'bulan': now.month,
                            'tahun': now.year,
                            'jam': '${now.hour}:${now.minute}',
                            'an': namaController.text,
                            'total': totalTransaksi,
                            'status': 'pending',
                            'pembayaran': 'tunai',
                          };
                          context
                              .read<TransaksiBloc>()
                              .add(SimpanTransaksi(dataTransaksi: data));
                          context.read<CartBloc>().add(GetCart());

                          Fluttertoast.showToast(msg: 'Transaksi Berhasil');
                          namaController.text = '';
                          mejaController.text = '';
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TransaksiPage()),
                          );
                        }
                      },
                      child: const Text('Selesai')),
                ],
              )
            ]),
          )),
    );
  }
}

// class CustomFiel extends StatelessWidget {
//   final String label;
//   final String validator;
//   final TextEditingController controller;
//   const CustomFiel(
//       {super.key,
//       required this.label,
//       required this.validator,
//       required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       textCapitalization: TextCapitalization.words,
//       decoration:
//           InputDecoration(border: const OutlineInputBorder(), labelText: label),
//       validator: (value) => (value == null || value.isEmpty) ? validator : null,
//     );
//   }
// }
