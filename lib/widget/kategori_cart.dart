import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/constant.dart';

class KategoriCart extends StatefulWidget {
  const KategoriCart({super.key});

  @override
  State<KategoriCart> createState() => _KategoriCartState();
}

class _KategoriCartState extends State<KategoriCart> {
  late int selectedId;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KategoriBloc, KategoriState>(builder: (context, state) {
      if (state is KategoriLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        KategoriLoaded kategoriLoaded = state as KategoriLoaded;

        if (kategoriLoaded.data.isEmpty) {
          return const Center(child: Text('Belum ada Kategori'));
        } else {
          // List<Widget> katChip = [];
          // katChip.add(
          //   tombolKategori(
          //       label: 'All',
          //       isSelected: selectedId == 0,
          //       filter: () {
          //         setState(() {
          //           selectedId = 0;
          //           CartBloc produk = BlocProvider.of<CartBloc>(context);
          //           produk.add(GetCart());
          //         });
          //       }),
          // );
          // return ListView.builder(
          //   itemCount: kategoriLoaded.data.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Material(
          //         color: Colors.transparent,
          //         child: SizedBox(
          //           height: 50,
          //           child: InkWell(
          //             onTap: () {
          //               setState(() {
          //                 selectedId = kategoriLoaded.data[index].id;
          //                 context.read<CartBloc>().add(GetCart(
          //                     idKategori: kategoriLoaded.data[index].id));
          //               });
          //             },
          //             child: Text(kategoriLoaded.data[index].nama),
          //           ),
          //         ));
          //   },
          // );
          List<Widget> katChip = [];
          katChip.add(
            tombolKategori(
                label: 'All',
                isSelected: selectedId == 0,
                filter: () {
                  setState(() {
                    selectedId = 0;
                    context.read<CartBloc>().add(GetCart());
                  });
                }),
          );
          katChip.addAll(kategoriLoaded.data.map((e) {
            return tombolKategori(
                label: e.nama,
                isSelected: selectedId == e.id,
                filter: () {
                  setState(() {
                    selectedId = e.id;
                    context.read<CartBloc>().add(GetCart(idKategori: e.id));
                  });
                });
          }).toList());
          return ListView(children: katChip);
        }
      }
    });
  }

  Widget tombolKategori({
    required String label,
    required bool isSelected,
    required Function() filter,
  }) {
    return Material(
        color: isSelected
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.primary,
        child: InkWell(
            onTap: filter,
            child: SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  label,
                  style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white),
                )))));
  }
}
