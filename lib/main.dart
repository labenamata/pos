import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pos_app/bloc/bahan/bahan_bloc.dart';
import 'package:pos_app/bloc/cart/cart_bloc.dart';
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/bloc/kategori/kategori_bloc.dart';
import 'package:pos_app/bloc/konfirmasi/konfirmasi_bloc.dart';
import 'package:pos_app/bloc/login/login_bloc.dart';
import 'package:pos_app/bloc/produk/produk_bloc.dart';
import 'package:pos_app/bloc/recipe/recipe_bloc.dart';
import 'package:pos_app/bloc/transaksi/transaksi_bloc.dart';
import 'package:pos_app/bloc/user/user_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pos_app/page/splash_screen.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
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
          BlocProvider<UserBloc>(create: (context) => UserBloc(UserLoading())),
        ],
        child: SafeArea(
          child: MaterialApp(
            title: 'Resto POS',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: GoogleFonts.poppins().fontFamily,
              colorSchemeSeed: Vx.hexToColor('B0D9B1'),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              fontFamily: GoogleFonts.poppins().fontFamily,
              colorSchemeSeed: const Color(0xFF2D3250),
              brightness: Brightness.dark,
            ),
            themeMode: ThemeMode.light,
            // ignore: prefer_const_constructors
            home: SplashScreen(),
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
          ),
        ));
  }
}
