import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as pic;
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bawah;
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/bloc/recipe_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/kategori_model.dart';
import 'package:pos_app/model/produk_model.dart';
import 'package:pos_app/page/produk/edit_recipe.dart';
import 'package:pos_app/page/produk/komponen/form_produk.dart';
import 'package:pos_app/page/produk/produk_page.dart';
import 'package:pos_app/widget/preview_page.dart';

class EditProduk extends StatefulWidget {
  const EditProduk({
    Key? key,
    this.picture,
    required this.detailProduk,
  }) : super(key: key);
  final Uint8List? picture;
  final Produk detailProduk;
  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pokokController = TextEditingController();
  TextEditingController jualController = TextEditingController();

  int idKategori = 0;
  Uint8List? gambar;
  Map<String, dynamic> initKategori = {
    'idKategori': 0,
    'nama': 'Pilih Kategori'
  };

  Uint8List? resizedImg;
  Uint8List? bytes;

  final picker = ImagePicker();
  final kategoriForm = GlobalKey<FormState>();
  final produkForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
    imageBloc.add(GetImage(widget.detailProduk.image));
    setState(() {
      initKategori = {
        'idKategori': widget.detailProduk.idKategori,
        'nama': widget.detailProduk.namaKategori
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.detailProduk.nama;
    pokokController.text = widget.detailProduk.hargaPokok.toString();
    jualController.text = widget.detailProduk.hargaJual.toString();

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          backgroundColor: backgroundcolor,
          title: const Text(
            'Edit Produk',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          leading: // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(
                    LineIcons.angleLeft,
                    color: textColor,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProdukPage()),
                    );
                  }),
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pemberitahuan'),
                        content: Text(
                            'Yakin akan menghapus "${widget.detailProduk.nama}" ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tidak'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              ProdukBloc produk =
                                  BlocProvider.of<ProdukBloc>(context);
                              produk
                                  .add(HapusProduk(id: widget.detailProduk.id));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProdukPage()),
                              );
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      );
                    });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: contentPadding),
                child: Icon(
                  LineIcons.trash,
                  size: 25,
                  color: textColor,
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: buildBottom(context),
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
                const SizedBox(
                  height: defaultPadding,
                ),
                Expanded(child: buildRecipe())
              ]),
        ),
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
            child: TextButton(
              style: TextButton.styleFrom(
                  side: const BorderSide(color: primaryColor, width: 2)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                ProdukBloc produk = BlocProvider.of<ProdukBloc>(context);

                pic.Image? img = pic.decodeImage(gambar!);
                pic.Image resized =
                    pic.copyResize(img!, width: 200, height: 200);
                resizedImg = Uint8List.fromList(pic.encodePng(resized));
                if (nameController.text.isNotEmpty &&
                    pokokController.text.isNotEmpty &&
                    jualController.text.isNotEmpty) {
                  produk.add(UpdateProduk(
                      id: widget.detailProduk.id,
                      nama: nameController.text,
                      hargaPokok: int.parse(pokokController.text),
                      hargaJual: int.parse(jualController.text),
                      idKategori: initKategori['idKategori'],
                      img: resizedImg!));
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: textColorInvert, fontSize: 16),
              ),
            ),
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
                        const Divider(),
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

  Widget buildFoto() {
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
                          child: Container(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Material(
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

  Column buildRecipe() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Text(
            'Recipe',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          const Spacer(),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditRecipe(
                              idProduk: widget.detailProduk.id,
                              nama: widget.detailProduk.nama,
                            )));
                //getImageFromGallery();
              },
              icon: const Icon(
                LineIcons.plus,
                color: textColorInvert,
              ),
              label: const Text(
                'Tambah Resep',
                style: TextStyle(color: textColorInvert),
              ))
        ],
      ),
      const SizedBox(
        height: contentPadding,
      ),
      const Divider(
        height: 0,
        color: primaryColor,
      ),
      const SizedBox(
        height: contentPadding,
      ),
      BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
        if (state is RecipeLoading) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              child: const Center(
                  child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              )),
            ),
          );
        } else {
          RecipeLoaded recipeLoaded = state as RecipeLoaded;
          if (recipeLoaded.data.isNotEmpty) {
            return Expanded(
                child: ListView.separated(
              itemCount: recipeLoaded.data.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: primaryColor,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Text(
                      recipeLoaded.data[index].nama,
                      style: const TextStyle(color: textColor),
                    ),
                    const Spacer(),
                    Text(
                      recipeLoaded.data[index].usage.toString(),
                      style: const TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Text(
                      recipeLoaded.data[index].satuan,
                      style: const TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ));
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
      })
    ]);
  }

  Container buildDetail(BuildContext context) {
    return Container(
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
              borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
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
        BlocBuilder<KategoriBloc, KategoriState>(builder: (context, state) {
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
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
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    label: Text('Harga Pokok'),
                    labelStyle: TextStyle(fontSize: 14, color: textColor),
                    focusColor: primaryColor,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: textColor))),
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
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    label: Text('Harga Jual'),
                    labelStyle: TextStyle(fontSize: 14, color: textColor),
                    focusColor: primaryColor,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: textColor))),
              ),
            ),
          ],
        ),
      ]),
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
