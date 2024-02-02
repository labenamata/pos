import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/constant.dart';

class LaporanBulanan extends StatefulWidget {
  const LaporanBulanan({super.key});

  @override
  State<LaporanBulanan> createState() => _LaporanBulananState();
}

class _LaporanBulananState extends State<LaporanBulanan> {
  TextEditingController dateInput = TextEditingController();
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(children: [
        TextField(
          controller: dateInput,
          readOnly: true,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              prefixIcon: Icon(
                LineIcons.calendarAlt,
                color: primaryColor,
              ),
              labelText: 'Bulan',
              labelStyle: TextStyle(color: textColor)),
          onTap: () async {
            final pickedDate = await showMonthYearPicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(DateTime.now().year),
              lastDate: DateTime(2100),
              locale: const Locale('id'),
            );

            if (pickedDate != null) {
              String formattedDate = DateFormat('MMM yyyy').format(pickedDate);

              setState(() {
                context.read<TransaksiBloc>().add(GetTransaksi(
                    status: 'finish',
                    bulan: pickedDate.month,
                    tahun: pickedDate.year));
                selectedDate = pickedDate;
                dateInput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}

            // DateTime? pickedDate = await showDatePicker(
            //     initialEntryMode: DatePickerEntryMode.calendarOnly,
            //     context: context,
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(DateTime.now().year),
            //     //DateTime.now() - not to allow to choose before today.
            //     lastDate: DateTime(2100));

            // if (pickedDate != null) {
            //   String formattedDate =
            //       DateFormat('yyyy-MM-dd').format(pickedDate);

            //   setState(() {
            //     dateInput.text =
            //         formattedDate; //set output date to TextField value.
            //   });
            // } else {}
          },
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
                      String tanggal =
                          '${transaksiLoaded.data.transaksiList[index].tanggal}/${transaksiLoaded.data.transaksiList[index].bulan}/${transaksiLoaded.data.transaksiList[index].tahun}';
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
                          '$tanggal (${transaksiLoaded.data.transaksiList[index].jam})',
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
      ]),
    );
  }
}
