import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/constant.dart';

class SearchMenu extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String)? fungsi;

  const SearchMenu({
    Key? key,
    required this.searchController,
    required this.fungsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: fungsi,
      decoration: const InputDecoration(
        isDense: true,
        suffixIcon: Icon(
          LineIcons.search,
        ),
        filled: true,
        hintText: 'Cari',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      ),
    );
  }
}
