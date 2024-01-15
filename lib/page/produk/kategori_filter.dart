import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/kategori_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/constant.dart';

class KategoriFilter extends StatefulWidget {
  const KategoriFilter({super.key});

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  int selectedId = 0;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        //set border radius more than 50% of height and width to make circle
      ),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        // decoration: const BoxDecoration(
        //     color: secondaryColor,
        //     borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              'Filter Kategori',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              color: textColor,
            ),
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
                          ProdukBloc produk =
                              BlocProvider.of<ProdukBloc>(context);
                          produk.add(GetProduk());
                        });
                      }),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width -
                      90 -
                      defaultPadding * 4,
                  child: BlocBuilder<KategoriBloc, KategoriState>(
                      builder: (context, state) {
                    if (state is KategoriLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      KategoriLoaded kategoriLoaded = state as KategoriLoaded;

                      return Builder(
                        builder: (context) {
                          if (kategoriLoaded.data.isEmpty) {
                            return const Center(
                                child: Text('Belum ada Kategori'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: kategoriLoaded.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return tombolKategori(
                                    label: kategoriLoaded.data[index].nama,
                                    isSelected: selectedId ==
                                        kategoriLoaded.data[index].id,
                                    filter: () {
                                      setState(() {
                                        selectedId =
                                            kategoriLoaded.data[index].id;
                                        ProdukBloc produk =
                                            BlocProvider.of<ProdukBloc>(
                                                context);
                                        produk.add(ProdukByKategori(
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
        ),
      ),
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
