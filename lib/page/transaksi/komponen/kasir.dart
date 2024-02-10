import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class Kasir extends StatelessWidget {
  final String nama;

  const Kasir({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    var capsuleColor = Theme.of(context).colorScheme.secondaryContainer;
    var capsuleTextColor = Theme.of(context).colorScheme.onSecondaryContainer;
    var textColor = Theme.of(context).colorScheme.onPrimary;
    return Row(
      children: [
        VStack([
          VxCapsule(
            height: 20,
            width: 50,
            backgroundColor: capsuleColor,
            child: const Text(
              'Kasir',
            ).text.color(capsuleTextColor).xs.make().objectCenter(),
          ),
          Text(
            nama,
          ).text.bold.xl4.tight.color(textColor).make(),
        ]),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: Icon(
              LineIcons.verticalEllipsis,
              color: textColor,
            ))
      ],
    );
  }
}
