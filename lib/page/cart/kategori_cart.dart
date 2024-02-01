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
          List<Widget> katChip = [];
          katChip.add(
            tombolKategori(
                label: 'All',
                isSelected: selectedId == 0,
                filter: () {
                  setState(() {
                    selectedId = 0;
                    CartBloc cart = BlocProvider.of<CartBloc>(context);
                    cart.add(GetCart());
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
                    CartBloc cart = BlocProvider.of<CartBloc>(context);
                    cart.add(GetCart(idKategori: e.id));
                  });
                });
          }).toList());
          return Wrap(alignment: WrapAlignment.start, children: katChip);
        }
      }
    });
  }

  Widget tombolKategori({
    required String label,
    required bool isSelected,
    required Function() filter,
  }) {
    return Container(
      padding: const EdgeInsets.only(right: defaultPadding),
      child: TextButton(
          style: ElevatedButton.styleFrom(
              side: const BorderSide(color: primaryColor),
              foregroundColor: isSelected ? Colors.white : textColor,
              backgroundColor: isSelected ? primaryColor : backgroundcolor),
          onPressed: filter,
          child: Text(label)),
    );
  }
}
