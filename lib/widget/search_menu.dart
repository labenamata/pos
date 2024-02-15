import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

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
    var capsuleColor = Theme.of(context).colorScheme.surfaceVariant;
    var capsuleTextColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return VxBox(
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
              controller: searchController,
              onChanged: fungsi,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintText: 'Cari Menu',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ).p16(),
    ).color(capsuleColor).rounded.make().pOnly(top: 24, left: 24, right: 24);
  }
}
