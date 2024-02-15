import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/widget/drawer.dart';
import 'package:pos_app/page/transaksi/transaksi_finish.dart';
import 'package:pos_app/page/transaksi/transaksi_pending.dart';

var faker = Faker();

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final GlobalKey<ScaffoldState> scKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scKey,
          drawer: const SideMenu(
            idx: 1,
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(LineIcons.bars),
              onPressed: () {
                scKey.currentState!.openDrawer();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<CartBloc>().add(EmptyCart());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartPage(
                                stat: 'baru',
                              )),
                    );
                  },
                  icon: const Icon(LineIcons.plus))
            ],
            elevation: 1,
            title: const Text('Transaksi'),
            centerTitle: true,
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              // indicator:
              //     BoxDecoration(color: Theme.of(context).colorScheme.primary),
              tabs: [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Finish',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [TransaksiPending(), TransaksiFinish()],
          ),
        ),
      ),
    );
  }
}
