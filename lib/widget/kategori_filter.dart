import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';

import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/constant.dart';

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
    return Row(
      children: [
        IconButton.filled(
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
          icon: const Icon(LineIcons.syncIcon),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showBottom(context);
            },
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultRadius))),
                filled: true,
                isDense: true,
                hintText: namaKategori,
                suffixIcon: const Icon(
                  LineIcons.angleDown,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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

// class KategoriFilter extends StatefulWidget {
//   const KategoriFilter({super.key});

//   @override
//   State<KategoriFilter> createState() => _KategoriFilterState();
// }

// class _KategoriFilterState extends State<KategoriFilter> {
//   int selectedId = 0;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<KategoriBloc, KategoriState>(builder: (context, state) {
//       if (state is KategoriLoading) {
//         return const Center(child: CircularProgressIndicator());
//       } else {
//         KategoriLoaded kategoriLoaded = state as KategoriLoaded;

//         return Builder(
//           builder: (context) {
//             if (kategoriLoaded.data.isEmpty) {
//               return const Center(child: Text('Belum ada Kategori'));
//             } else {
//               List<Widget> katChip = [];
//               katChip.add(
//                 tombolKategori(
//                     label: 'All',
//                     isSelected: selectedId == 0,
//                     filter: () {
//                       setState(() {
//                         selectedId = 0;
//                         ProdukBloc produk =
//                             BlocProvider.of<ProdukBloc>(context);
//                         produk.add(GetProduk());
//                       });
//                     }),
//               );
//               katChip.addAll(kategoriLoaded.data.map((e) {
//                 return tombolKategori(
//                     label: e.nama,
//                     isSelected: selectedId == e.id,
//                     filter: () {
//                       setState(() {
//                         selectedId = e.id;

//                         context
//                             .read<ProdukBloc>()
//                             .add(ProdukByKategori(idKategori: e.id));
//                       });
//                     });
//               }).toList());
//               return Wrap(alignment: WrapAlignment.start, children: katChip);
//             }
//           },
//         );
//       }
//     });
//   }

//   Widget tombolKategori({
//     required String label,
//     required bool isSelected,
//     required Function() filter,
//   }) {
//     return Container(
//       padding: const EdgeInsets.only(right: defaultPadding),
//       child: TextButton(
//           style: ElevatedButton.styleFrom(
//               //side: const BorderSide(color: primaryColor),
//               foregroundColor: isSelected
//                   ? Colors.white
//                   : Theme.of(context).colorScheme.primary,
//               backgroundColor: isSelected
//                   ? Theme.of(context).colorScheme.onPrimaryContainer
//                   : Theme.of(context).colorScheme.primaryContainer),
//           onPressed: filter,
//           child: Text(label)),
//     );
//   }
// }
