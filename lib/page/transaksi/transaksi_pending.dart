import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/page/transaksi/komponen/list_pesanan.dart';
import 'package:pos_app/page/transaksi/komponen/search_pesanan.dart';
import 'package:velocity_x/velocity_x.dart';

class TransaksiPending extends StatefulWidget {
  const TransaksiPending({super.key});

  @override
  State<TransaksiPending> createState() => _TransaksiPendingState();
}

class _TransaksiPendingState extends State<TransaksiPending> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(GetTransaksi(status: 'pending'));
  }

  @override
  Widget build(BuildContext context) {
    return VStack([
      const SearchPesanan(),
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
            return ListPesanan(dataTransaksi: transaksiLoaded.data);
          }
        }
      })
    ]);
  }
}
