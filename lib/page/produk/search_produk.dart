import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:line_icons/line_icons.dart';

Widget searchProduk(BuildContext context) {
  TextEditingController searchController = TextEditingController();
  return TextField(
    onEditingComplete: () {
      context.read<ProdukBloc>().add(SearchProduk(nama: searchController.text));
    },
    onChanged: (value) {
      if (value.isEmpty) {
        context.read<ProdukBloc>().add(SearchProduk(nama: ''));
      }
    },
    decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        suffixIcon: const Icon(
          LineIcons.search,
          color: primaryColor,
        ),
        labelText: 'Cari',
        hintStyle: TextStyle(color: textColor.withOpacity(0.5))),
    controller: searchController,
  );
}
