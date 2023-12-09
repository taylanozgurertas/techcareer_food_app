// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/data/entity/favlanan_urun.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';
import 'package:yemekler_uygulamasi/ui/cubit/favsayfa_cubit.dart';

// ignore: must_be_immutable
class FavSayfa extends StatefulWidget {
  List<Yemekler> favlananUrunler = [];

  FavSayfa({
    Key? key,
  }) : super(key: key);

  @override
  State<FavSayfa> createState() => _FavSayfaState();
}

class _FavSayfaState extends State<FavSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<FavSayfaCubit>().urunleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorilerim"),
      ),
      body: BlocBuilder<FavSayfaCubit, List<FavlananUrun>>(builder: (context, favlananUrunlerListesi) {
        if (favlananUrunlerListesi.isNotEmpty) {
          return ListView.builder(
            itemCount: favlananUrunlerListesi.length,
            itemBuilder: (context, indeks) {
              var urun = favlananUrunlerListesi[indeks];
              return Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: context.general.mediaQuery.size.height / 8,
                      height: context.general.mediaQuery.size.width / 4,
                      child: Image.network("${Metinler.temelResimUrl}${urun.urun_resim_adi}")),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(urun.urun_adi, style: const TextStyle(fontFamily: Metinler.fontAdi, fontSize: 20)),
                      ),
                      Text(
                        "Fiyat: ₺${urun.urun_fiyati}",
                        style: const TextStyle(fontFamily: Metinler.fontAdi, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ));
            },
          );
        } else {
          return const Center(child: Text("Favori ürün seçilmemiş"));
        }
      }),
    );
  }
}
