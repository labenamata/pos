import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/transaksi/transaksi_pending.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  var formatter = DateFormat('dd-MMM-yyyy');
  late String selectedDateFormat;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedDateFormat = formatter.format(selectedDate);
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> getDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2024, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateFormat = formatter.format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Transaksi',
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData().copyWith(splashColor: primaryColor),
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.white, //<-- selected text color
          unselectedLabelColor: textColor,
          indicatorColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
              color: primaryColor), //<-- Unselected text color
          tabs: const <Widget>[
            Tab(
              child: Text(
                'Pending',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Finish',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CartBloc cart = BlocProvider.of<CartBloc>(context);
          cart.add(GetCart());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                const Text(
                  'Tanggal',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  color: textColor,
                ),
                Row(
                  children: [
                    Text(
                      selectedDateFormat,
                      style: const TextStyle(color: textColor, fontSize: 16),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                        label: const Text(
                          'Ganti tanggal',
                          style: TextStyle(color: textColor),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () => getDate(context),
                        icon: const Icon(Icons.calendar_month))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                TransaksiPending(),
                Center(
                  child: Text("It's rainy here"),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
