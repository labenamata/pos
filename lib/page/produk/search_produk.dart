import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:line_icons/line_icons.dart';

Widget searchProduk(BuildContext context) {
  TextEditingController searchController = TextEditingController();
  return TextField(
    onEditingComplete: () {
      ProdukBloc produk = BlocProvider.of<ProdukBloc>(context);
      produk.add(SearchProduk(nama: searchController.text));
    },
    onChanged: (value) {
      if (value.isEmpty) {
        ProdukBloc produk = BlocProvider.of<ProdukBloc>(context);
        produk.add(SearchProduk(nama: ''));
      }
    },
    decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: primaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: textColor),
        ),
        focusColor: primaryColor,
        suffixIcon: const Icon(
          LineIcons.search,
          color: primaryColor,
        ),
        labelText: 'Cari',
        labelStyle: const TextStyle(color: textColor),
        hintStyle: TextStyle(color: textColor.withOpacity(0.5))),
    controller: searchController,
  );
}
