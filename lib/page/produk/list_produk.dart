import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/bloc/recipe/recipe_bloc.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/model/produk_model.dart';
import 'package:pos_app/page/produk/edit_produk.dart';
import 'package:pos_app/widget/loading_shimer.dart';

Widget listProduk() {
  return BlocBuilder<ProdukBloc, ProdukState>(builder: (context, state) {
    if (state is ProdukLoading) {
      return produkLoading();
    } else {
      ProdukLoaded produkLoaded = state as ProdukLoaded;

      if (produkLoaded.data.isNotEmpty) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10, crossAxisSpacing: 10, crossAxisCount: 2),
          itemCount: produkLoaded.data.length,
          itemBuilder: (BuildContext context, int index) {
            return produkTile(
                detailData: produkLoaded.data[index], context: context);
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
  });
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
          context.read<RecipeBloc>().add(GetRecipe(id: detailData.id));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProduk(
                      detailProduk: detailData,
                    )),
          );
        });
      },
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        child: Stack(
          alignment: Alignment.bottomCenter,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(defaultRadius)),
              child: Image.memory(
                detailData.image,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(defaultRadius),
                      bottomRight: Radius.circular(defaultRadius))),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailData.nama,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatter.format(detailData.hargaJual),
                    style: TextStyle(
                        fontSize: 14,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
