import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
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
    decoration: const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: defaultPadding),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: textColor),
      ),
      focusColor: primaryColor,
      suffixIcon: Icon(
        LineIcons.search,
        color: primaryColor,
      ),
      labelText: 'Cari',
      labelStyle: TextStyle(color: textColor),
    ),
    controller: searchController,
  );
}
