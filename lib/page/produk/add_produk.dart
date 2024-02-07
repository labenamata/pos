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
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: // Ensure Scaffold is in context
            IconButton(
                icon: const Icon(
                  LineIcons.angleLeft,
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
                height: defaultPadding * 2,
              ),
              buildBottom(context)
            ]),
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              // style: OutlinedButton.styleFrom(
              //     side: const BorderSide(color: primaryColor, width: 2)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 14),
              )),
        ),
        const SizedBox(
          width: defaultPadding,
        ),
        Expanded(
          child: ElevatedButton(
              //style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
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
                style: TextStyle(fontSize: 14),
              )),
        )
      ],
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
                    height: MediaQuery.sizeOf(context).height - 200,
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Kategori',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: Icon(LineIcons.times),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
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
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    label: Text('Nama Kategori'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: contentPadding,
                              ),
                              IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  if (kategoriForm.currentState!.validate()) {
                                    context
                                        .read<KategoriBloc>()
                                        .add(TambahKategori(
                                          name: namaKategori.text,
                                        ));

                                    namaKategori.text = '';
                                  }
                                },
                                icon: const Icon(
                                  LineIcons.plus,
                                  color: Colors.white,
                                ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
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
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kategori.nama,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 15.0,
                ),
              ),
              VerticalDivider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              GestureDetector(
                onTap: () {
                  context
                      .read<KategoriBloc>()
                      .add(HapusKategori(id: kategori.id));
                },
                child: Icon(
                  LineIcons.times,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            ],
          ),
        ));
  }

  Column buildFoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: contentPadding,
        ),
        Container(
          //width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
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
                                    child: Row(
                                      children: [
                                        Icon(
                                          LineIcons.image,
                                          size: 50,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                        const Text(
                                          'Galeri',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const Spacer(),
                                        const Icon(LineIcons.angleRight)
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
                                    child: Row(
                                      children: [
                                        Icon(
                                          LineIcons.camera,
                                          size: 50,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                        const Text(
                                          'Kamera',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const Spacer(),
                                        const Icon(LineIcons.angleRight)
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
                    Icon(
                      LineIcons.camera,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
