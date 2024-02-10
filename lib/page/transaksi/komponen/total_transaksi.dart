import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/transaksi_model.dart';
import 'package:velocity_x/velocity_x.dart';

class TotalTransaksi extends StatelessWidget {
  final Transaksi dataTransaksi;
  const TotalTransaksi({
    Key? key,
    required this.dataTransaksi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).colorScheme.onTertiary;
    var terColor = Theme.of(context).colorScheme.tertiary;
    return HStack([
      Expanded(
          child: VxBox(
                  child: VStack([
        const Text('Jumlah Transaksi').text.color(textColor).make(),
        Text(formatter.format(dataTransaksi.transaksiList.length))
            .text
            .xl
            .color(textColor)
            .bold
            .make()
      ]).p12())
              .rounded
              .color(terColor)
              .make()),
      const SizedBox(
        width: Vx.dp12,
      ),
      Expanded(
          child: VxBox(
                  child: VStack([
        const Text('Total Transaksi').text.color(textColor).make(),
        Text(formatter.format(dataTransaksi.total))
            .text
            .xl
            .color(textColor)
            .bold
            .make()
      ]).p12())
              .rounded
              .color(terColor)
              .make()),
    ]).pOnly(top: 24, left: 24, right: 24);
  }
}
