import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/page/transaksi/transaksi_page.dart';

var faker = Faker();

class SideMenu extends StatefulWidget {
  final int idx;
  const SideMenu({
    Key? key,
    required this.idx,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late int currentPageIndex;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.idx;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        // setState(() {
        //   currentPageIndex = index;
        // });
        switch (index) {
          case 0:
            if (currentPageIndex != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProdukPage()),
              );
            }

            break;
          case 1:
            if (currentPageIndex != 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TransaksiPage()),
              );
            }
            break;
        }
      },
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(faker.person.firstName()),
            accountEmail: Text(faker.internet.email())),
        const NavigationDrawerDestination(
          icon: Icon(LineIcons.file),
          label: Text('Menu'),
          selectedIcon: Icon(LineIcons.fileContract),
        ),
        const NavigationDrawerDestination(
          icon: Icon(LineIcons.shoppingCart),
          label: Text('Transaksi'),
          selectedIcon: Icon(LineIcons.addToShoppingCart),
        ),
        const Divider(indent: 28, endIndent: 28),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(LineIcons.powerOff),
            label: const Text('Keluar'))
      ],
    );
  }
}
