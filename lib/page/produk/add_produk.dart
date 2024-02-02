import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bawah;
import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/kategori_model.dart';
import 'package:pos_app/page/produk/komponen/form_produk.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/widget/preview_page.dart';
import 'package:image/image.dart' as pic;

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
  TextEditingController katController = TextEditingController();
  int idKategori = 0;
  Map<String, dynamic> initKategori = {
    'idKategori': 0,
    'nama': 'Pilih Kategori'
  };
  Uint8List? gambar;

  Uint8List? resizedImg;
  Uint8List? bytes;

  final picker = ImagePicker();
  final kategoriForm = GlobalKey<FormState>();
  final produkForm = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: backgroundcolor,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: // Ensure Scaffold is in context
            IconButton(
                icon: const Icon(
                  LineIcons.angleLeft,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProdukPage()),
                  );
                }),
      ),
      //bottomNavigationBar: buildBottom(context),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              buildFoto(),
              const SizedBox(
                height: defaultPadding,
              ),
              buildKategori(),
              const SizedBox(
                height: defaultPadding,
              ),
              FormProduk(
                  formKey: produkForm,
                  nameController: nameController,
                  pokokController: pokokController,
                  jualController: jualController),
              const SizedBox(
                height: defaultPadding,
              ),
              buildBottom(context)
            ]),
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryColor, width: 2)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Batal',
                  style: TextStyle(color: textColor, fontSize: 14),
                )),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  if (produkForm.currentState!.validate()) {
                    //ProdukBloc produk = BlocProvider.of<ProdukBloc>(context);

                    pic.Image? img = pic.decodeImage(gambar!);
                    pic.Image resized =
                        pic.copyResize(img!, width: 200, height: 200);
                    resizedImg = Uint8List.fromList(pic.encodePng(resized));

                    context.read<ProdukBloc>().add(TambahProduk(
                        nama: nameController.text,
                        hargaPokok: int.parse(pokokController.text),
                        hargaJual: int.parse(jualController.text),
                        idKategori: initKategori['idKategori'],
                        img: resizedImg!));
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: textColorInvert, fontSize: 14),
                )),
          )
        ],
      ),
    );
  }

  Widget buildKategori() {
    TextEditingController namaKategori = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori *',
          style: TextStyle(color: textColor, fontSize: 14),
        ),
        const SizedBox(
          height: contentPadding,
        ),
        GestureDetector(
          onTap: () {
            bawah.showMaterialModalBottomSheet(
                expand: false,
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultPadding))),
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height / 2,
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Kategori',
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ),
                        ),
                        // const Divider(),
                        Form(
                          key: kategoriForm,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: namaKategori,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukan Nama Kategori';
                                    }
                                    return null;
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorColor: primaryColor,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      label: Text('Nama Kategori'),
                                      labelStyle: TextStyle(color: textColor),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: textColor))),
                                ),
                              ),
                              const SizedBox(
                                width: contentPadding,
                              ),
                              IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () {
                                  if (kategoriForm.currentState!.validate()) {
                                    KategoriBloc kategori =
                                        BlocProvider.of<KategoriBloc>(context);
                                    kategori.add(TambahKategori(
                                      name: namaKategori.text,
                                    ));
                                    namaKategori.text = '';
                                  }
                                },
                                icon: const Icon(LineIcons.plus),
                                color: textColorInvert,
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
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            KategoriLoaded kategoriLoaded =
                                state as KategoriLoaded;
                            if (kategoriLoaded.data.isEmpty) {
                              return const Center(
                                  child: Text('Belum ada Kategori'));
                            } else {
                              if (idKategori == 0) {
                                idKategori = kategoriLoaded.data.first.id;
                              }
                              return Wrap(
                                spacing: 10, // gap between adjacent chips
                                runSpacing: 10,
                                alignment: WrapAlignment.start,
                                children: kategoriLoaded.data.map((e) {
                                  return tagChip(kategori: e);
                                }).toList(),
                              );
                            }
                          }
                        }),
                      ],
                    ),
                  );
                });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                initKategori['nama'],
                style: const TextStyle(color: primaryColor),
              ),
              const Spacer(),
              const Icon(LineIcons.angleDown)
            ],
          ),
        )
      ],
    );
  }

  Widget tagChip({
    required Kategori kategori,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: () {
          setState(() {
            initKategori = {'idKategori': kategori.id, 'nama': kategori.nama};
          });
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  kategori.nama,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  context
                      .read<KategoriBloc>()
                      .add(HapusKategori(id: kategori.id));
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10.0,
                  child: Icon(
                    LineIcons.times,
                    size: 10.0,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Column buildFoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto',
          style: TextStyle(color: textColor, fontSize: 14),
        ),
        const SizedBox(
          height: contentPadding,
        ),
        Container(
          //width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius:
                  const BorderRadius.all(Radius.circular(defaultRadius))),
          child: BlocBuilder<ImageBloc, ImageState>(builder: (context, state) {
            if (state is ImageLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              ImageLoaded imageLoaded = state as ImageLoaded;
              gambar = imageLoaded.imgData;
              return GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: backgroundcolor,
                          child: Container(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const PreviewPage(
                                                  picFrom: 'gal')));
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          LineIcons.image,
                                          size: 50,
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Text(
                                          'Galeri',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Spacer(),
                                        Icon(LineIcons.angleRight)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: contentPadding,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const PreviewPage(
                                                  picFrom: 'cam')));
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          LineIcons.camera,
                                          size: 50,
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Text(
                                          'Kamera',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Spacer(),
                                        Icon(LineIcons.angleRight)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(defaultRadius),
                      child: Image.memory(
                        imageLoaded.imgData,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const Icon(
                      LineIcons.camera,
                      color: primaryColor,
                    )
                  ],
                ),
              );
            }
          }),
        ),
      ],
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
