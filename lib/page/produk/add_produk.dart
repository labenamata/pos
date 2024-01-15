import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/bloc/image_bloc.dart';

import 'package:pos_app/bloc/kategori_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/widget/preview_page.dart';
import 'package:image/image.dart' as IMG;

class ProdukTambah extends StatefulWidget {
  const ProdukTambah({
    Key? key,
    this.picture,
  }) : super(key: key);
  final XFile? picture;
  @override
  State<ProdukTambah> createState() => _ProdukTambahState();
}

class _ProdukTambahState extends State<ProdukTambah> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pokokController = TextEditingController();
  TextEditingController jualController = TextEditingController();
  int idKategori = 0;
  Uint8List? gambar;

  Uint8List? resizedImg;
  Uint8List? bytes;

  final picker = ImagePicker();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        elevation: 0,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: // Ensure Scaffold is in context
            IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProdukPage()),
                  );
                }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 300,
                //padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultRadius))),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(defaultRadius))),
                        child: BlocBuilder<ImageBloc, ImageState>(
                            builder: (context, state) {
                          if (state is ImageLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            ImageLoaded imageLoaded = state as ImageLoaded;
                            gambar = imageLoaded.imgData;
                            return Image.memory(imageLoaded.imgData);
                          }
                        }),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PreviewPage(picFrom: 'gal')));
                                //getImageFromGallery();
                              },
                              icon: const Icon(Icons.photo_camera_back),
                              label: const Text('Galeri')),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor),
                              onPressed: () async {
                                //final cameras = await availableCameras();
                                //getImageFromCamera();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PreviewPage(picFrom: 'cam')));
                              },
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Camera')),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              BlocBuilder<KategoriBloc, KategoriState>(
                  builder: (context, state) {
                if (state is KategoriLoading) {
                  return const CircularProgressIndicator();
                } else {
                  KategoriLoaded kategoriLoaded = state as KategoriLoaded;

                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultPadding))),
                          child: Builder(
                            builder: (context) {
                              if (kategoriLoaded.data.isEmpty) {
                                return const Text('Belum ada Kategori');
                              } else {
                                if (idKategori == 0) {
                                  idKategori = kategoriLoaded.data.first.id;
                                }
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      padding: EdgeInsets.zero,
                                      isDense: true,
                                      value: idKategori == 0
                                          ? kategoriLoaded.data.first.id
                                          : idKategori,
                                      items: kategoriLoaded.data.map((item) {
                                        return DropdownMenuItem(
                                          value: item.id,
                                          child: Text(item.nama),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          idKategori = value!;
                                        });
                                      }),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          label: const Text('Kategori'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return addKategori(context);
                                });
                          },
                          icon: const Icon(Icons.add))
                    ],
                  );
                }
              }),
              const SizedBox(
                height: defaultPadding,
              ),
              TextField(
                controller: nameController,
                cursorColor: primaryColor,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    label: Text('Nama Produk'),
                    labelStyle: TextStyle(fontSize: 14, color: textColor),
                    focusColor: primaryColor,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: textColor))),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pokokController,
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: primaryColor),
                          ),
                          label: Text('Harga Pokok'),
                          labelStyle: TextStyle(fontSize: 14, color: textColor),
                          focusColor: primaryColor,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: textColor))),
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  Expanded(
                    child: TextField(
                      controller: jualController,
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: primaryColor),
                          ),
                          label: Text('Harga Jual'),
                          labelStyle: TextStyle(fontSize: 14, color: textColor),
                          focusColor: primaryColor,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: textColor))),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400]),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.dangerous_rounded),
                        label: const Text('Batal')),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () {
                          ProdukBloc produk =
                              BlocProvider.of<ProdukBloc>(context);

                          IMG.Image? img = IMG.decodeImage(gambar!);
                          IMG.Image resized =
                              IMG.copyResize(img!, width: 200, height: 200);
                          resizedImg =
                              Uint8List.fromList(IMG.encodePng(resized));
                          if (nameController.text.isNotEmpty &&
                              pokokController.text.isNotEmpty &&
                              jualController.text.isNotEmpty) {
                            produk.add(TambahProduk(
                                nama: nameController.text,
                                hargaPokok: int.parse(pokokController.text),
                                hargaJual: int.parse(jualController.text),
                                idKategori: idKategori,
                                img: resizedImg!));
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Lengkapi Data Terlebih Dahulu');
                          }
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save')),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

Widget addKategori(BuildContext context) {
  TextEditingController nameController = TextEditingController();

  return Dialog(
    child: Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(color: secondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tambah Kategori',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
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
          TextField(
            controller: nameController,
            cursorColor: primaryColor,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: primaryColor),
                ),
                label: Text('Nama Kategori'),
                labelStyle: TextStyle(fontSize: 14, color: textColor),
                focusColor: primaryColor,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: textColor))),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.dangerous_rounded),
                    label: const Text('Batal')),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      KategoriBloc kategori =
                          BlocProvider.of<KategoriBloc>(context);
                      kategori.add(TambahKategori(
                        name: nameController.text,
                      ));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save')),
              )
            ],
          )
        ],
      ),
    ),
  );
}
