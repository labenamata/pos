import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/produk/add_produk.dart';
import 'package:pos_app/widget/drawer.dart';
import 'package:pos_app/widget/kategori_filter.dart';
import 'package:pos_app/page/produk/list_produk.dart';
import 'package:pos_app/widget/navigation_bar.dart';
import 'package:pos_app/widget/search_menu.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ProdukBloc>().add(GetProduk());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: const SideMenu(
          idx: 0,
        ),
        appBar: AppBar(
          title: const Text(
            'Produk',
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child:
                  FilledButton(onPressed: () {}, child: const Text('Kategori')),
            )
          ],
        ),
        bottomNavigationBar: const NavMenu(
          pageIndex: 1,
        ),
        body: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SearchMenu(
                searchController: searchController,
                fungsi: (val) {
                  context
                      .read<ProdukBloc>()
                      .add(SearchProduk(nama: searchController.text));
                }),
            const SizedBox(
              height: defaultPadding,
            ),
            const KategoriFilter(
              page: 'produk',
            ),
            const SizedBox(
              height: contentPadding,
            ),
            Expanded(child: listProduk())
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              context.read<ImageBloc>().add(GetImage(null));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProdukTambah()),
              );
            },
            child: const Icon(
              LineIcons.plus,
            )),
      ),
    );
  }
}
