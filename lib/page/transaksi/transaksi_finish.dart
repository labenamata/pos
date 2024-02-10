import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/page/transaksi/komponen/date_select.dart';
import 'package:pos_app/page/transaksi/komponen/list_pesanan.dart';
import 'package:pos_app/page/transaksi/komponen/total_transaksi.dart';
import 'package:velocity_x/velocity_x.dart';

class TransaksiFinish extends StatefulWidget {
  const TransaksiFinish({super.key});

  @override
  State<TransaksiFinish> createState() => _TransaksiFinishState();
}

class _TransaksiFinishState extends State<TransaksiFinish> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(GetTransaksi(
        tanggal: DateTime.now().day,
        bulan: DateTime.now().month,
        tahun: DateTime.now().year,
        status: 'finish'));
  }

  @override
  Widget build(BuildContext context) {
    return VStack([
      const DateSelect(),
      BlocBuilder<TransaksiBloc, TransaksiState>(builder: (context, state) {
        if (state is TransaksiLoading) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          TransaksiLoaded transaksiLoaded = state as TransaksiLoaded;

          if (transaksiLoaded.data.transaksiList.isEmpty) {
            return const Expanded(
                child: Center(
              child: Text('Belum Ada Transaksi'),
            ));
          } else {
            return Expanded(
              child: VStack(
                [
                  TotalTransaksi(dataTransaksi: transaksiLoaded.data),
                  ListPesanan(dataTransaksi: transaksiLoaded.data),
                ],
              ),
            );
          }
        }
      })
    ]);
  }
}
