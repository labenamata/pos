import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/produk_bloc.dart';
import 'package:pos_app/bloc/recipe_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/produk_model.dart';
import 'package:pos_app/page/produk/edit_produk.dart';

Widget listProduk() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      //set border radius more than 50% of height and width to make circle
    ),
    child: Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: defaultPadding,
          ),
          const Text(
            'Produk',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          const Divider(
            color: textColor,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Expanded(
            child:
                BlocBuilder<ProdukBloc, ProdukState>(builder: (context, state) {
              if (state is ProdukLoading) {
                return Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: primaryColor,
                  )),
                );
              } else {
                ProdukLoaded produkLoaded = state as ProdukLoaded;

                if (produkLoaded.data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: produkLoaded.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return produkTile(
                          detailData: produkLoaded.data[index],
                          context: context);
                    },
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: const Center(
                      child: Text('Belum ada data'),
                    ),
                  );
                }

                //
              }
            }),
          ),
        ],
      ),
    ),
  );
}

Widget produkTile({required Produk detailData, required BuildContext context}) {
  // ImageProvider provider2 =
  //     ExtendedMemoryImageProvider(image, cacheRawData: true);
  return Material(
    color: Colors.transparent,
    child: InkWell(
      splashColor: textColor,
      onTap: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          RecipeBloc recipeBloc = BlocProvider.of<RecipeBloc>(context);
          recipeBloc.add(GetRecipe(id: detailData.id));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProduk(
                      detailProduk: detailData,
                    )),
          );
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                detailData.image,
                height: 80.0,
                width: 80.0,
              ),
            ),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detailData.nama,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(
                formatter.format(detailData.hargaJual),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
