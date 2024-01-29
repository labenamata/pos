import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/drawer.dart';
import 'package:pos_app/page/produk/add_produk.dart';
import 'package:pos_app/page/produk/kategori_filter.dart';
import 'package:pos_app/page/produk/list_produk.dart';
import 'package:pos_app/page/produk/search_produk.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  void initState() {
    ProdukBloc produk = BlocProvider.of<ProdukBloc>(context);
    produk.add(GetProduk());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      drawer: menuDrawer(context),
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        scrolledUnderElevation: 0,
        title: const Text(
          'Produk',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading:
            // Ensure Scaffold is in context
            Builder(builder: (context) {
          return IconButton(
              icon: const Icon(
                LineIcons.bars,
                color: textColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(children: [
          searchProduk(context),
          const SizedBox(
            height: defaultPadding,
          ),
          const KategoriFilter(),
          const SizedBox(
            height: contentPadding,
          ),
          Expanded(child: listProduk())
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
            imageBloc.add(GetImage(null));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProdukTambah()),
            );
          },
          child: const Icon(
            Icons.add,
            //size: 50,
            //color: textColor,
          )),
    );
  }
}
