import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bawah;
import 'package:pos_app/bloc/bahan_bloc.dart';
import 'package:pos_app/bloc/recipe_bloc.dart';

import 'package:pos_app/constant.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({
    Key? key,
    required this.idProduk,
    required this.nama,
  }) : super(key: key);
  final int idProduk;
  final String nama;

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  int idBahan = 0;
  String nama = '';
  String satuan = '';

  TextEditingController usageController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController satuanController = TextEditingController();

  late FocusNode focusUsage;
  late FocusNode focusNama;

  @override
  void initState() {
    super.initState();
    focusUsage = FocusNode();
    focusNama = FocusNode();
  }

  @override
  void dispose() {
    focusUsage.dispose();
    focusNama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: backgroundcolor,
          title: Text(
            widget.nama,
            style: const TextStyle(color: textColor),
          ),
          leading: // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(
                    LineIcons.angleLeft,
                    color: textColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    LineIcons.check,
                    color: textColor,
                  )),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(children: [
            buildBahan(),
            const SizedBox(
              height: defaultPadding,
            ),
            Expanded(child: buildRecipe())
          ]),
        ),
      ),
    );
  }

  Container buildRecipe() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: defaultPadding,
        ),
        const Text(
          'Daftar Recipe',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        const Divider(
          color: primaryColor,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child:
              BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
            if (state is RecipeLoading) {
              return Container(
                padding: const EdgeInsets.all(defaultPadding),
                child: const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: primaryColor,
                )),
              );
            } else {
              RecipeLoaded recipeLoaded = state as RecipeLoaded;
              if (recipeLoaded.data.isNotEmpty) {
                return ListView.separated(
                  itemCount: recipeLoaded.data.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: primaryColor,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Notifikasi'),
                                  content:
                                      const Text('Yakin Akan Menghapus Data ?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Tidak')),
                                    TextButton(
                                        onPressed: () {
                                          RecipeBloc recipeBloc =
                                              BlocProvider.of<RecipeBloc>(
                                                  context);
                                          recipeBloc.add(HapusRecipe(
                                              id: recipeLoaded.data[index].id,
                                              idProduk: widget.idProduk));
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ya'))
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          recipeLoaded.data[index].nama,
                          style: const TextStyle(color: textColor),
                        ),
                        const Spacer(),
                        Text(
                          recipeLoaded.data[index].usage.toString(),
                          style: const TextStyle(color: textColor),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          recipeLoaded.data[index].satuan,
                          style: const TextStyle(color: textColor),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: const Center(
                    child: Text(
                      'Belum Ada Data',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              }
            }
          }),
        )
      ]),
    );
  }

  Column buildBahan() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Text(
                'Bahan Baku',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              Spacer(),
            ],
          ),
          const Divider(
            color: primaryColor,
          ),
          const SizedBox(
            height: contentPadding,
          ),
          const Text(
            'Nama Bahan Baku',
            style: TextStyle(color: textColor),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Material(
            color: secondaryColor,
            child: InkWell(
              splashColor: textColor,
              onTap: () {
                bawah.showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return buildAddBahan(context);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(defaultPadding)),
                ),
                child: Row(children: [
                  idBahan == 0
                      ? const Text(
                          'Cari',
                          style: TextStyle(color: textColor),
                        )
                      : Text(
                          nama,
                          style: const TextStyle(color: textColor),
                        ),
                  const Spacer(),
                  const Icon(
                    Icons.search_rounded,
                    color: primaryColor,
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusUsage,
                  controller: usageController,
                  cursorColor: primaryColor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      suffixText: satuan,
                      label: const Text('Usage'),
                      labelStyle: const TextStyle(color: primaryColor),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: contentPadding),
                      isDense: true,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: textColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: primaryColor),
                      )),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    RecipeBloc recipeBloc =
                        BlocProvider.of<RecipeBloc>(context);
                    if (idBahan != 0) {
                      if (usageController.text.isNotEmpty) {
                        recipeBloc.add(TambahRecipe(
                          idProduk: widget.idProduk,
                          idBahan: idBahan,
                          usage: double.parse(usageController.text),
                        ));
                        setState(() {
                          idBahan = 0;
                          nama = '';
                          satuan = '';
                        });

                        usageController.text = '';
                        focusUsage.unfocus();
                      } else {
                        focusUsage.requestFocus();
                      }
                    }

                    // Navigator.pop(context);
                  },
                  icon: const Icon(LineIcons.plus),
                  label: const Text('Tambah')),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Satuan',
              //         style: TextStyle(color: textColor),
              //       ),
              //       Center(
              //         child: Container(
              //             width: double.infinity,
              //             padding: const EdgeInsets.all(defaultPadding),
              //             decoration: BoxDecoration(
              //               border: Border.all(color: primaryColor),
              //               borderRadius: const BorderRadius.all(
              //                   Radius.circular(defaultPadding)),
              //             ),
              //             child: Text(
              //               satuan,
              //               style: const TextStyle(color: textColor),
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
        ]);
  }

  Material buildAddBahan(BuildContext context) {
    return Material(
        color: backgroundcolor,
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(defaultRadius))),
                  child: TextField(
                    onEditingComplete: () {
                      BahanBloc produk = BlocProvider.of<BahanBloc>(context);
                      produk.add(SearchBahan(nama: searchController.text));
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        BahanBloc produk = BlocProvider.of<BahanBloc>(context);
                        produk.add(SearchBahan(nama: searchController.text));
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: const Icon(
                          Icons.search_rounded,
                          color: backgroundcolor,
                        ),
                        hintText: 'Search nama produk',
                        hintStyle:
                            TextStyle(color: textColor.withOpacity(0.5))),
                    controller: searchController,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Container(
                  //height: 50,
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(defaultRadius))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const Text(
                        'Tambah Bahan Baku',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const Divider(
                        color: primaryColor,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            controller: namaController,
                            cursorColor: primaryColor,
                            focusNode: focusNama,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: primaryColor),
                                ),
                                label: Text('Nama Bahan'),
                                labelStyle:
                                    TextStyle(fontSize: 14, color: textColor),
                                focusColor: primaryColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: textColor))),
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: TextField(
                            controller: satuanController,
                            cursorColor: primaryColor,
                            //textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: primaryColor),
                                ),
                                label: Text('Satuan'),
                                labelStyle:
                                    TextStyle(fontSize: 14, color: textColor),
                                focusColor: primaryColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: textColor))),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (namaController.text.isNotEmpty &&
                                  satuanController.text.isNotEmpty) {
                                BahanBloc bahan =
                                    BlocProvider.of<BahanBloc>(context);
                                bahan.add(TambahBahan(
                                  name: namaController.text,
                                  satuan: satuanController.text,
                                ));
                                satuanController.text = '';
                                namaController.text = '';
                                focusNama.requestFocus();
                              }
                            },
                            icon: const Icon(Icons.save_rounded),
                            iconSize: 40,
                            color: primaryColor,
                            style: IconButton.styleFrom(
                                backgroundColor: primaryColor))
                      ]),
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Expanded(
                  child: Container(
                    //height: 50,
                    // ignore: prefer_const_constructors
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          'Daftar Bahan Baku',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Divider(
                          color: primaryColor,
                        ),
                        BlocBuilder<BahanBloc, BahanState>(
                            builder: (context, state) {
                          if (state is BahanLoading) {
                            return Container(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: primaryColor,
                              )),
                            );
                          } else {
                            BahanLoaded bahanLoaded = state as BahanLoaded;
                            if (bahanLoaded.data.isNotEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: bahanLoaded.data.length,
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: primaryColor,
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${bahanLoaded.data[index].nama} (${bahanLoaded.data[index].satuan})',
                                          style:
                                              const TextStyle(color: textColor),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Notifikasi'),
                                                  content: const Text(
                                                      'Yakin Akan Menghapus Data ?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Tidak')),
                                                    TextButton(
                                                        onPressed: () {
                                                          BahanBloc bahan =
                                                              BlocProvider.of<
                                                                      BahanBloc>(
                                                                  context);
                                                          bahan.add(HapusBahan(
                                                            id: bahanLoaded
                                                                .data[index].id,
                                                          ));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('Ya'))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.close_rounded),
                                        ),
                                        IconButton(
                                          color: primaryColor,
                                          onPressed: () {
                                            setState(() {
                                              idBahan =
                                                  bahanLoaded.data[index].id;
                                              nama =
                                                  bahanLoaded.data[index].nama;
                                              satuan = bahanLoaded
                                                  .data[index].satuan;
                                            });
                                            focusUsage.requestFocus();
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.add),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: const Center(
                                    child: Text(
                                      'Belum Ada Data',
                                      style: TextStyle(color: textColor),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
