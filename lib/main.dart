import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/constants/renkler.dart';
import 'package:yemekler_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:yemekler_uygulamasi/ui/cubit/detay_sayfa_cubit.dart';
import 'package:yemekler_uygulamasi/ui/cubit/favsayfa_cubit.dart';
import 'package:yemekler_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:yemekler_uygulamasi/ui/views/tab_sayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => DetaySayfaCubit()),
        BlocProvider(create: (context) => SepetSayfaCubit()),
        BlocProvider(create: (context) => FavSayfaCubit()),
      ],
      child: MaterialApp(
        title: Metinler.uygBaslik,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
          appBarTheme: const AppBarTheme(
              foregroundColor: Renkler.beyazRenk,
              backgroundColor: Renkler.siyahRenk,
              systemOverlayStyle: SystemUiOverlayStyle.light),
        ),
        home: const TabSayfa(),
      ),
    );
  }
}
