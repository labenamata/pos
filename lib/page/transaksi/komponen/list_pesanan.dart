import 'package:pos_app/model/transaksi_model.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';

var faker = Faker();
const Map<int, String> monthsInYear = {
  1: 'JAN',
  2: 'FEB',
  3: 'MAR',
  4: 'APR',
  5: 'MEI',
  6: 'JUN',
  7: 'JUL',
  8: 'AGU',
  9: 'SEP',
  10: 'OKT',
  11: 'NOV',
  12: 'DES'
};

class ListPesanan extends StatelessWidget {
  final Transaksi dataTransaksi;
  const ListPesanan({
    Key? key,
    required this.dataTransaksi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primColor = Theme.of(context).colorScheme.primary;
    var secondColor = Theme.of(context).colorScheme.secondary;
    var primaryContainerColor =
        Theme.of(context).colorScheme.secondaryContainer;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Vx.dp24),
        child: ListView.separated(
          itemCount: dataTransaksi.transaksiList.length,
          itemBuilder: (BuildContext context, int index) {
            return VxBox(
                child: SizedBox(
              height: 75,
              child: HStack(
                [
                  VStack(
                    [
                      Text(dataTransaksi.transaksiList[index].tahun.toString())
                          .text
                          .color(secondColor)
                          .make(),
                      Text(dataTransaksi.transaksiList[index].tanggal.length < 2
                              ? '0${dataTransaksi.transaksiList[index].tanggal}'
                              : dataTransaksi.transaksiList[index].tanggal
                                  .toString())
                          .text
                          .color(primColor)
                          .xl2
                          .bold
                          .italic
                          .make(),
                      Text(monthsInYear[
                              dataTransaksi.transaksiList[index].bulan]!)
                          .text
                          .xl
                          .color(secondColor)
                          .make()
                    ],
                    axisSize: MainAxisSize.max,
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.spaceBetween,
                  ),
                  VStack(
                    [
                      Text('#${dataTransaksi.transaksiList[index].id}')
                          .text
                          .color(secondColor)
                          .make(),
                      Text(dataTransaksi.transaksiList[index].an)
                          .text
                          .xl
                          .bold
                          .make(),
                      Text('Meja No : ${dataTransaksi.transaksiList[index].meja}')
                          .text
                          .color(secondColor)
                          .make(),
                    ],
                    axisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceBetween,
                  ),
                  const Spacer(),
                  VStack(
                    [
                      const Text('Total').text.color(secondColor).make(),
                      Text(formatter
                              .format(dataTransaksi.transaksiList[index].total))
                          .text
                          .color(primColor)
                          .xl2
                          .bold
                          .make(),
                      Text('${dataTransaksi.transaksiList[index].detailTransaksi.length} Item')
                          .text
                          .color(secondColor)
                          .make(),
                    ],
                    axisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceBetween,
                    crossAlignment: CrossAxisAlignment.center,
                  )
                ],
                spacing: Vx.dp24,
              ),
            )).color(primaryContainerColor).rounded.p12.make();
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: Vx.dp24,
            );
          },
        ),
      ),
    );
  }
}
