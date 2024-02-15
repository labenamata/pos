import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';

import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:velocity_x/velocity_x.dart';

class KategoriFilter extends StatefulWidget {
  final String page;

  const KategoriFilter({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  String namaKategori = 'Kategori Filter';
  bool isRefresh = false;
  @override
  Widget build(BuildContext context) {
    var capsuleColor = Theme.of(context).colorScheme.surfaceVariant;
    var capsuleTextColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return HStack(
      [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showBottom(context);
            },
            child: VxBox(
              child: HStack(
                [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        isDense: true,
                        hintText: namaKategori,
                      ),
                    ),
                  ),
                  Icon(
                    LineIcons.angleDown,
                    color: capsuleTextColor,
                  ),
                ],
              ),
            ).rounded.p16.color(capsuleColor).make(),
          ),
        ),
        const SizedBox(
          width: Vx.dp12,
        ),
        FloatingActionButton(
          tooltip: 'Refresh',
          onPressed: isRefresh
              ? null
              : () {
                  setState(() {
                    isRefresh = true;
                    namaKategori = 'Kategori Filter';
                  });
                  if (widget.page == 'produk') {
                    context.read<ProdukBloc>().add(GetProduk());
                  } else {
                    context.read<CartBloc>().add(GetCart());
                  }
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      isRefresh = false;
                    });
                  });
                },
          child: const Icon(LineIcons.syncIcon),
        ),
      ],
    ).pOnly(top: 24, left: 24, right: 24);
  }

  Future<void> showBottom(BuildContext context) {
    return showModalBottomSheet<void>(
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 400,
            child: Column(
              children: [
                BlocBuilder<KategoriBloc, KategoriState>(
                    builder: (context, state) {
                  if (state is KategoriLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    KategoriLoaded kategoriLoaded = state as KategoriLoaded;

                    return Expanded(
                      child: ListView.separated(
                        itemCount: kategoriLoaded.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            type: MaterialType.card,
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  if (widget.page == 'produk') {
                                    context.read<ProdukBloc>().add(
                                        ProdukByKategori(
                                            idKategori:
                                                kategoriLoaded.data[index].id));
                                  } else {
                                    context.read<CartBloc>().add(GetCart(
                                        idKategori:
                                            kategoriLoaded.data[index].id));
                                  }

                                  setState(() {
                                    namaKategori =
                                        kategoriLoaded.data[index].nama;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding, vertical: 8),
                                  child: SizedBox(
                                      height: 25,
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Text(kategoriLoaded
                                                .data[index].nama),
                                          ],
                                        ),
                                      )),
                                )),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    );
                  }
                })
              ],
            ),
          );
        });
  }
}
