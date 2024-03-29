import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';

class LaporanHarian extends StatelessWidget {
  const LaporanHarian({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyDateTimeLine(
          locale: 'id',
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            int tanggal = selectedDate.day;
            int bulan = selectedDate.month;
            int tahun = selectedDate.year;
            context.read<TransaksiBloc>().add(GetTransaksi(
                status: 'finish',
                tanggal: tanggal,
                bulan: bulan,
                tahun: tahun));
          },
          activeColor: primaryColor,
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
          ),
          dayProps: const EasyDayProps(
            height: 50,
            width: 50,
            //landScapeMode: true,
            dayStructure: DayStructure.dayStrDayNum,
            activeDayStyle: DayStyle(
              borderRadius: defaultRadius,
            ),
            inactiveDayStyle: DayStyle(
              borderRadius: defaultRadius,
            ),
          ),
          timeLineProps: const EasyTimeLineProps(
            hPadding: 15, // padding from left and right
            separatorPadding: 16.0, // padding between days
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Expanded(child: BlocBuilder<TransaksiBloc, TransaksiState>(
            builder: (context, state) {
          if (state is TransaksiLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else {
            TransaksiLoaded transaksiLoaded = state as TransaksiLoaded;

            return Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    decoration: const BoxDecoration(color: primaryColor),
                    child: Row(children: [
                      const Text(
                        'Total Penjualan : ',
                        style: TextStyle(color: textColorInvert),
                      ),
                      const Spacer(),
                      Text(formatter.format(transaksiLoaded.data.total),
                          style: const TextStyle(color: textColorInvert))
                    ]),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: primaryColor,
                      );
                    },
                    itemCount: transaksiLoaded.data.transaksiList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                color: transaksiLoaded.data.transaksiList[index]
                                            .pembayaran ==
                                        'tunai'
                                    ? Colors.green
                                    : Colors.amber,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(defaultRadius))),
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                transaksiLoaded
                                    .data.transaksiList[index].pembayaran,
                                style: const TextStyle(color: textColorInvert),
                              ),
                            ),
                          ),
                        ),
                        title: transaksiLoaded
                                    .data.transaksiList[index].pembayaran ==
                                'tunai'
                            ? const Text('Penjualan')
                            : Text(
                                transaksiLoaded.data.transaksiList[index].an),
                        subtitle: Text(
                          transaksiLoaded.data.transaksiList[index].jam,
                          style: const TextStyle(color: textColor),
                        ),
                        trailing: Text(
                          formatter.format(
                              transaksiLoaded.data.transaksiList[index].total),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }))
      ],
    );
  }
}
