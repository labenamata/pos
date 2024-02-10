import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

var formatDate = DateFormat('d-MMM-yyyy');

class DateSelect extends StatefulWidget {
  const DateSelect({super.key});

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2024, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        context.read<TransaksiBloc>().add(GetTransaksi(
            tanggal: picked.day,
            bulan: picked.month,
            tahun: picked.year,
            status: 'finish'));
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VxBox(
            child: HStack([
      VStack(
        [
          const Text('Tanggal')
              .text
              .color(Theme.of(context).colorScheme.secondary)
              .make(),
          Text(formatDate.format(selectedDate.toLocal())).text.bold.xl.make(),
        ],
      ),
      const Spacer(),
      IconButton(
          constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
          onPressed: () {
            selectDate(context);
          },
          icon: const Icon(
            LineIcons.calendar,
            size: 30,
          ))
    ]).p24())
        .color(Theme.of(context).colorScheme.secondaryContainer)
        .rounded
        .make()
        .pOnly(top: 24, left: 24, right: 24);
  }
}
