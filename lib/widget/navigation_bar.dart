import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/page/transaksi/transaksi_page.dart';

class NavMenu extends StatefulWidget {
  final int pageIndex;

  const NavMenu({super.key, required this.pageIndex});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  late int currentPageIndex;
  @override
  void initState() {
    super.initState();
    setState(() {
      currentPageIndex = widget.pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        // setState(() {
        //   currentPageIndex = index;
        // });
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProdukPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransaksiPage()),
            );
            break;
        }
      },
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(LineIcons.home),
          label: 'Home',
          selectedIcon: Icon(LineIcons.warehouse),
        ),
        NavigationDestination(
          icon: Icon(LineIcons.file),
          label: 'Menu',
          selectedIcon: Icon(LineIcons.fileContract),
        ),
        NavigationDestination(
          icon: Icon(LineIcons.shoppingCart),
          label: 'Transaksi',
          selectedIcon: Icon(LineIcons.addToShoppingCart),
        ),
        NavigationDestination(
          selectedIcon: Icon(LineIcons.wordFileAlt),
          icon: Icon(LineIcons.wordFile),
          label: 'Report',
        ),
      ],
    );
  }
}
