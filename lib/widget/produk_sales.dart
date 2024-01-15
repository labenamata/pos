import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';

Widget produkSales(BuildContext context) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      //set border radius more than 50% of height and width to make circle
    ),
    child: SizedBox(
      height: 300,
      //width: double.infinity,
      // decoration: const BoxDecoration(
      //     color: secondaryColor,
      //     borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              'Produk',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const Text(
              'Lima produk dengan penjualan terbanyak',
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              color: textColor,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Expanded(
                child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  favList(namaProduk: 'Nasi Goreng Seafood', jumlah: '200+'),
                  favList(namaProduk: 'Nasi Goreng Original', jumlah: '200+'),
                  favList(namaProduk: 'Ayam Bakar', jumlah: '200+'),
                  favList(namaProduk: 'Es Teh', jumlah: '200+'),
                  favList(namaProduk: 'Es Jeruk', jumlah: '200+')
                ],
              ),
            ))
          ],
        ),
      ),
    ),
  );
}

ListTile favList({required String namaProduk, required String jumlah}) {
  return ListTile(
    //dense: true,
    contentPadding: const EdgeInsets.all(0),
    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    title: Text(
      namaProduk,
      style: const TextStyle(color: textColor),
    ),
    trailing: Text(
      jumlah,
      style: const TextStyle(color: textColor),
    ),
  );
}
