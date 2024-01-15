import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/constant.dart';

Widget searchProdukCart(BuildContext context) {
  TextEditingController searchController = TextEditingController();
  return TextField(
    onEditingComplete: () {
      CartBloc cart = BlocProvider.of<CartBloc>(context);
      cart.add(GetCart(nama: searchController.text));
    },
    onChanged: (value) {
      if (value.isEmpty) {
        CartBloc cart = BlocProvider.of<CartBloc>(context);
        cart.add(GetCart());
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
          Icons.search_rounded,
          color: textColor,
        ),
        labelText: 'Cari',
        labelStyle: const TextStyle(color: textColor),
        //label: const Text('Cari'),
        //hintText: 'Cari',
        hintStyle: TextStyle(color: textColor.withOpacity(0.5))),
    controller: searchController,
  );
}
