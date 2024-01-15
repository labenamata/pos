import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/constant.dart';

Widget searchProduk(BuildContext context) {
  TextEditingController searchController = TextEditingController();
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      //set border radius more than 50% of height and width to make circle
    ),
    child: Container(
      height: 50,
      // ignore: prefer_const_constructors
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      // decoration: const BoxDecoration(
      //     color: secondaryColor,
      //     borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      child: TextField(
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
            border: InputBorder.none,
            suffixIcon: const Icon(
              Icons.search_rounded,
              color: textColor,
            ),
            hintText: 'Search nama produk',
            hintStyle: TextStyle(color: textColor.withOpacity(0.5))),
        controller: searchController,
      ),
    ),
  );
}
