import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/report/laporan_bulanan.dart';
import 'package:pos_app/page/report/laporan_harian.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  DateTime focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          backgroundColor: backgroundcolor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'Laporan Penjualan',
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
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
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: textColor,
            labelColor: textColorInvert,
            indicator: BoxDecoration(color: primaryColor),
            tabs: [
              Tab(
                text: 'Harian',
              ),
              Tab(text: 'Bulanan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LaporanHarian(),
            LaporanBulanan(),
          ],
        ),
      ),
    );
  }
}
