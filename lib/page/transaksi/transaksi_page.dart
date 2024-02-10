import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/page/transaksi/transaksi_finish.dart';
import 'package:pos_app/page/transaksi/transaksi_pending.dart';

var faker = Faker();

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LineIcons.bars),
            onPressed: () {},
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(LineIcons.plus))
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
    );
  }
}
