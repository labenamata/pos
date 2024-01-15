import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/cart_bloc.dart';
import 'package:pos_app/bloc/kategori_bloc.dart';
import 'package:pos_app/constant.dart';

class KategoriCart extends StatefulWidget {
  const KategoriCart({super.key});

  @override
  State<KategoriCart> createState() => _KategoriCartState();
}

class _KategoriCartState extends State<KategoriCart> {
  late int selectedId;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              height: 40,
              child: tombolKategori(
                  label: 'All',
                  isSelected: selectedId == 0,
                  filter: () {
                    setState(() {
                      selectedId = 0;
                      CartBloc cart = BlocProvider.of<CartBloc>(context);
                      cart.add(GetCart());
                    });
                  }),
            ),
            SizedBox(
              height: 40,
              width:
                  MediaQuery.of(context).size.width - 90 - defaultPadding * 2,
              child: BlocBuilder<KategoriBloc, KategoriState>(
                  builder: (context, state) {
                if (state is KategoriLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  KategoriLoaded kategoriLoaded = state as KategoriLoaded;

                  return Builder(
                    builder: (context) {
                      if (kategoriLoaded.data.isEmpty) {
                        return const Center(child: Text('Belum ada Kategori'));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: kategoriLoaded.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return tombolKategori(
                                label: kategoriLoaded.data[index].nama,
                                isSelected:
                                    selectedId == kategoriLoaded.data[index].id,
                                filter: () {
                                  setState(() {
                                    selectedId = kategoriLoaded.data[index].id;
                                    CartBloc cart =
                                        BlocProvider.of<CartBloc>(context);
                                    cart.add(GetCart(
                                        idKategori:
                                            kategoriLoaded.data[index].id));
                                  });
                                });
                          },
                        );
                        // return ListView.builder(
                        //   scrollDirection: Axis.horizontal,
                        //   itemCount: kategoriLoaded.data.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return tombolKategori(
                        //         label: kategoriLoaded.data[index].nama,
                        //         isSelected: selectedId ==
                        //             kategoriLoaded.data[index].id,
                        //         filter: () {
                        //           setState(() {
                        //             selectedId =
                        //                 kategoriLoaded.data[index].id;
                        //           });
                        //         });
                        //   },
                        // );
                      }
                    },
                  );
                }
              }),
            )
          ],
        ),
      ],
    );
  }

  Widget tombolKategori({
    required String label,
    required bool isSelected,
    required Function() filter,
  }) {
    return Container(
      padding: const EdgeInsets.only(right: defaultPadding),
      child: TextButton(
          style: ElevatedButton.styleFrom(

              //side: const BorderSide(color: primaryColor),
              foregroundColor: isSelected ? Colors.white : textColor,
              backgroundColor: isSelected ? primaryColor : backgroundcolor),
          onPressed: filter,
          child: Text(label)),
    );
  }
}
