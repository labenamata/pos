import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';
import 'package:shimmer/shimmer.dart';

Widget produkLoading() {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //childAspectRatio: 1 / 2,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //elevation: 1,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius))),
          );
        },
      ));
}
