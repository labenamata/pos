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

  Column buildRecipe() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: defaultPadding,
      ),
      const Text(
        'Recipe :',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
      const SizedBox(
        height: contentPadding,
      ),
      const Divider(
        color: primaryColor,
      ),
      const SizedBox(
        height: contentPadding,
      ),
      Expanded(
        child: BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
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
                padding: EdgeInsets.zero,
                itemCount: recipeLoaded.data.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: primaryColor,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
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
                        child: const Icon(LineIcons.times),
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
    ]);
  }

  Row buildBahan() {
    return Row(children: [
      Expanded(
        child: Material(
          //color: secondaryColor,
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
              padding: const EdgeInsets.symmetric(vertical: contentPadding),
              // decoration: const BoxDecoration(
              //     border: Border(bottom: BorderSide(color: primaryColor))),
              child: Row(children: [
                const Icon(
                  LineIcons.angleDown,
                  color: primaryColor,
                ),
                const SizedBox(
                  width: contentPadding,
                ),
                idBahan == 0
                    ? const Text(
                        'Cari Bahan Baku',
                        style: TextStyle(color: textColor, fontSize: 20),
                      )
                    : Text(
                        nama,
                        style:
                            const TextStyle(color: primaryColor, fontSize: 20),
                      ),
              ]),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 70,
        child: TextField(
          focusNode: focusUsage,
          controller: usageController,
          cursorColor: primaryColor,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              suffixText: satuan,
              prefixText: ':',
              //label: const Text('Usage'),
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
      IconButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        onPressed: () {
          RecipeBloc recipeBloc = BlocProvider.of<RecipeBloc>(context);
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
                SizedBox(
                  height: 60,
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
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: contentPadding),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          color: backgroundcolor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: primaryColor),
                        ),
                        labelText: 'Nama Bahan',
                        labelStyle: TextStyle(color: primaryColor)),
                    controller: searchController,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: contentPadding,
                    ),
                    const Text(
                      'Tambah Bahan Baku',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    const SizedBox(
                      height: contentPadding,
                    ),
                    const Divider(
                      color: primaryColor,
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: textColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: primaryColor),
                            ),
                            label: Text('Nama Bahan'),
                            labelStyle:
                                TextStyle(fontSize: 14, color: textColor),
                            focusColor: primaryColor,
                          ),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: textColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: primaryColor),
                            ),
                            label: Text('Satuan'),
                            labelStyle:
                                TextStyle(fontSize: 14, color: textColor),
                            focusColor: primaryColor,
                          ),
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
                const SizedBox(
                  height: defaultPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: contentPadding,
                      ),
                      const Text(
                        'Daftar Bahan Baku',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      const SizedBox(
                        height: contentPadding,
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
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Notifikasi'),
                                                content: const Text(
                                                    'Yakin Akan Menghapus Data ?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Tidak')),
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
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Ya'))
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          LineIcons.times,
                                          color: primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Text(
                                        '${bahanLoaded.data[index].nama} (${bahanLoaded.data[index].satuan})',
                                        style:
                                            const TextStyle(color: textColor),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        color: primaryColor,
                                        onPressed: () {
                                          setState(() {
                                            idBahan =
                                                bahanLoaded.data[index].id;
                                            nama = bahanLoaded.data[index].nama;
                                            satuan =
                                                bahanLoaded.data[index].satuan;
                                          });
                                          focusUsage.requestFocus();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(LineIcons.plus),
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
                )
              ],
            ),
          ),
        ));
  }
}
