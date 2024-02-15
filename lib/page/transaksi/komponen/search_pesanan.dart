import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchPesanan extends StatelessWidget {
  const SearchPesanan({super.key});

  @override
  Widget build(BuildContext context) {
    var capsuleColor = Theme.of(context).colorScheme.surfaceVariant;
    var capsuleTextColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return HStack(
      [
        Expanded(
          child: VxBox(
            child: HStack(
              [
                Icon(
                  LineIcons.search,
                  color: capsuleTextColor,
                ),
                const SizedBox(
                  width: Vx.dp12,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: capsuleTextColor),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: 'Cari Pesanan',
                        border: InputBorder.none
                        //filled: true,
                        ),
                  ),
                ),
              ],
            ),
          ).color(capsuleColor).rounded.p16.make(),
        ),
        const SizedBox(
          width: Vx.dp12,
        ),
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(LineIcons.syncIcon),
        )
      ],
    ).pOnly(top: 24, left: 24, right: 24);
  }
}
