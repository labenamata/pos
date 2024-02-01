import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/bloc/bahan_bloc.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/bloc/konfirmasi_bloc.dart';
import 'package:pos_app/bloc/login/login_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/bloc/recipe_bloc.dart';
import 'package:pos_app/bloc/transaksi_bloc.dart';
import 'package:pos_app/page/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<KategoriBloc>(
              create: (context) =>
                  KategoriBloc(KategoriLoading(''))..add(GetKategori())),
          BlocProvider<ProdukBloc>(
              create: (context) =>
                  ProdukBloc(ProdukLoading(''))..add(GetProduk())),
          BlocProvider<ImageBloc>(
              create: (context) =>
                  ImageBloc(ImageLoading())..add(GetImage(null))),
          BlocProvider<BahanBloc>(
              create: (context) =>
                  BahanBloc(BahanLoading(''))..add(GetBahan())),
          BlocProvider<RecipeBloc>(
              create: (context) => RecipeBloc(RecipeLoading(''))),
          BlocProvider<TransaksiBloc>(
              create: (context) => TransaksiBloc(TransaksiLoading())),
          BlocProvider<CartBloc>(
              create: (context) => CartBloc(CartLoading(''))..add(GetCart())),
          BlocProvider<KonfirmasiBloc>(
              create: (context) =>
                  KonfirmasiBloc(KonfirmasiLoading(''))..add(GetKonfirmasi())),
          BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        ],
        child: SafeArea(
          child: MaterialApp(
            title: 'POS Application',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                useMaterial3: true,
                fontFamily: GoogleFonts.poppins().fontFamily),
            home: const LoginPage(),
          ),
        ));
  }
}
