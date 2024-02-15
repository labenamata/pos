import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/widget/drawer.dart';
import 'package:pos_app/widget/grafik_sales.dart';
import 'package:pos_app/widget/produk_sales.dart';
import 'package:pos_app/widget/total_sales.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      //drawer: menuDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: textColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
        ),
        backgroundColor: backgroundcolor,
        elevation: 0,
        //centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(children: [
            totalSales(),
            const SizedBox(
              height: defaultPadding,
            ),
            grafikSales(),
            const SizedBox(
              height: defaultPadding,
            ),
            produkSales(context)
          ]),
        ),
      ),
    );
  }
}
