import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bawah;
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/bloc/kategori_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/bloc/recipe_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/produk_model.dart';
import 'package:pos_app/page/produk/edit_recipe.dart';
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
          elevation: 1,
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
                TextField(
                  controller: nameController,
                  cursorColor: primaryColor,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: primaryColor),
                      ),
                      label: Text('Nama Produk *'),
                      labelStyle: TextStyle(fontSize: 14, color: textColor),
                      focusColor: primaryColor,
                      enabledBorder: UnderlineInputBorder(
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
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: primaryColor),
                            ),
                            label: Text('Harga Pokok *'),
                            labelStyle:
                                TextStyle(fontSize: 14, color: textColor),
                            focusColor: primaryColor,
                            enabledBorder: UnderlineInputBorder(
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
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: primaryColor),
                            ),
                            label: Text('Harga Jual *'),
                            labelStyle:
                                TextStyle(fontSize: 14, color: textColor),
                            focusColor: primaryColor,
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: textColor))),
                      ),
                    ),
                  ],
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

  Container buildBottom(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Material(
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius)),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(defaultRadius)),
                    ),
                    child: const Center(
                      child: Text(
                        'Batal',
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                )),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: Material(
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius)),
                child: InkWell(
                  onTap: () {
                    ProdukBloc produk = BlocProvider.of<ProdukBloc>(context);

                    IMG.Image? img = IMG.decodeImage(gambar!);
                    IMG.Image resized =
                        IMG.copyResize(img!, width: 200, height: 200);
                    resizedImg = Uint8List.fromList(IMG.encodePng(resized));
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
                  child: Container(
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(defaultRadius)),
                    ),
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(color: textColorInvert, fontSize: 16),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Column buildKategori() {
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
                      children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: namaKategori,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                cursorColor: primaryColor,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    label: Text('Nama Kategori'),
                                    labelStyle: TextStyle(color: primaryColor),
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
                            GestureDetector(
                              onTap: () {
                                KategoriBloc kategori =
                                    BlocProvider.of<KategoriBloc>(context);
                                kategori.add(TambahKategori(
                                  name: namaKategori.text,
                                ));
                                namaKategori.text = '';
                              },
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(defaultRadius))),
                                  child: const Icon(
                                    LineIcons.plus,
                                    color: textColorInvert,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Expanded(
                          child: BlocBuilder<KategoriBloc, KategoriState>(
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
                                return ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: kategoriLoaded.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          bottom: defaultPadding),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            LineIcons.times,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(
                                            width: defaultPadding,
                                          ),
                                          Expanded(
                                            child: Material(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          defaultRadius)),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    initKategori = {
                                                      'idKategori':
                                                          kategoriLoaded
                                                              .data[index].id,
                                                      'nama': kategoriLoaded
                                                          .data[index].nama
                                                    };
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      contentPadding),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  defaultRadius)),
                                                      border: Border.all(
                                                          color: primaryColor)),
                                                  child: Row(
                                                    children: [
                                                      Text(kategoriLoaded
                                                          .data[index].nama),
                                                      const Spacer(),
                                                      const Icon(
                                                        LineIcons.angleRight,
                                                        color: primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    // return Text(
                                    //     kategoriLoaded.data[index].nama);
                                    // return ListTile(
                                    //   horizontalTitleGap: 0,
                                    //   visualDensity: const VisualDensity(
                                    //       horizontal: 0, vertical: -4),
                                    //   leading: const Icon(LineIcons.dotCircle),
                                    //   trailing:
                                    //       const Icon(LineIcons.windowCloseAlt),
                                    //   contentPadding: EdgeInsets.zero,
                                    //   title:
                                    //       Text(kategoriLoaded.data[index].nama),
                                    // );
                                  },
                                );
                              }
                            }
                          }),
                        ),
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

  Container buildRecipe() {
    return Container(
      //padding: const EdgeInsets.all(defaultPadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                icon: const Icon(LineIcons.plus),
                label: const Text('Tambah Resep'))
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
      ]),
    );
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
