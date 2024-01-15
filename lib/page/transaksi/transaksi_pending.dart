import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';

class TransaksiPending extends StatefulWidget {
  const TransaksiPending({super.key});

  @override
  State<TransaksiPending> createState() => _TransaksiPendingState();
}

class _TransaksiPendingState extends State<TransaksiPending> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      child: const Column(
        children: [
          SizedBox(
            height: defaultPadding,
          ),
          Text(
            'Tanggal',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Divider(
            color: textColor,
          ),
        ],
      ),
    );
  }
}
