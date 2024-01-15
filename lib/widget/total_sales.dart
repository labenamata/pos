import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';

Widget totalSales() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      //set border radius more than 50% of height and width to make circle
    ),
    child: Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: defaultPadding,
          ),
          const Text(
            'Sales',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          const Text(
            'Rangkuman total penjualan',
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
          const Text(
            'Hari Ini',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total',
                            style: TextStyle(fontSize: 14, color: textColor)),
                        Text('Rp 20.000.000',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Profit',
                            style: TextStyle(fontSize: 14, color: textColor)),
                        Text('Rp 4.000.000',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Jumlah Transaksi',
                            style: TextStyle(fontSize: 14, color: textColor)),
                        Text('500',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Produk',
                            style: TextStyle(fontSize: 14, color: textColor)),
                        Text('200 Item',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
        ],
      ),
    ),
  );
}
