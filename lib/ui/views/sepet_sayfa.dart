import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/constants/sayilar.dart';
import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';

// ignore: must_be_immutable
class SepetSayfa extends StatefulWidget {
  String? resimAdi = Metinler.hop;

  SepetSayfa({super.key, this.resimAdi});

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {
  int genelToplam = Sayilar.kZeros;

  void updateGenelToplam(List<Sepet> sepet) {
    Future.delayed(Duration.zero, () {
      if (!mounted) {
        return;
      }

      try {
        Map<String, GruplanmisUrun> gruplanmisUrunler = {};
        int yeniGenelToplam = 0;

        sepet.forEach((urun) {
          var urunAdi = urun.yemek_adi;
          var urunResimAdi = urun.yemek_resim_adi;
          var sepetYemekId = urun.sepet_yemek_id;

          var gruplanmisUrun = gruplanmisUrunler.putIfAbsent(
            urunAdi,
            () => GruplanmisUrun(urunAdi, urunResimAdi, Sayilar.kZeros, int.parse(sepetYemekId)),
          );

          int adet = int.parse(urun.yemek_siparis_adet);
          gruplanmisUrun.toplamAdet += adet;

          yeniGenelToplam += int.parse(urun.yemek_fiyat) * adet;
        });

        setState(() {
          genelToplam = yeniGenelToplam;
          groupedSepet = gruplanmisUrunler.values.toList();
        });
      } catch (e, stackTrace) {
        print("${Metinler.hataOlustu}$e");
        print("$stackTrace");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<SepetSayfaCubit>().sepettekiUrunleriCek("taylan_deneme");
  }

  List<GruplanmisUrun> groupedSepet = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Metinler.sepetimYazi),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SepetSayfaCubit, List<Sepet>>(
              builder: (context, sepet) {
                if (sepet.isNotEmpty) {
                  updateGenelToplam(sepet);
                  return ListView.builder(
                    itemCount: groupedSepet.length,
                    itemBuilder: (context, indeks) {
                      var gruplanmisUrun = groupedSepet[indeks];
                      return Card(
                        child: ListTile(
                          leading: gruplanmisUrun.urunResimAdi.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage('${Metinler.temelResimUrl}${gruplanmisUrun.urunResimAdi}'),
                                )
                              : const SizedBox.shrink(),
                          title: Text(gruplanmisUrun.urunAdi),
                          subtitle: Text("${Metinler.adet}${gruplanmisUrun.toplamAdet}"),
                          trailing: Column(
                            children: [
                              Builder(
                                builder: (context) {
                                  try {
                                    var urun = sepet.firstWhere((urun) => urun.yemek_adi == gruplanmisUrun.urunAdi);
                                    double urunFiyat = double.parse(urun.yemek_fiyat);
                                    double toplamFiyat = gruplanmisUrun.toplamAdet * urunFiyat;

                                    return Text(
                                      "${Metinler.toplamT}$toplamFiyat",
                                    );
                                  } catch (e) {
                                    print("${Metinler.hataOlustu}$e");
                                    // Hata durumunda
                                    return const Text(
                                      Metinler.defaultToplam,
                                    );
                                  }
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  context
                                      .read<SepetSayfaCubit>()
                                      .sepetUrunSil(gruplanmisUrun.sepetYemekId, "taylan_deneme")
                                      .then((silindi) {
                                    if (silindi) {
                                      //! Ürün başarıyla silindi, sepeti güncelle
                                      context.read<SepetSayfaCubit>().sepettekiUrunleriCek("taylan_deneme");
                                      setState(() {
                                        groupedSepet.removeAt(indeks);
                                        if (groupedSepet.isEmpty) {
                                          genelToplam = 0;
                                        }
                                      });
                                    }
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  genelToplam = 0;

                  return const Center(child: Text(Metinler.sepetteUrunYok));
                }
              },
            ),
          ),
          Padding(
            padding: Sayilar.defaultPad,
            child: Text(
              "${Metinler.toplamT}$genelToplam",
              style: context.general.textTheme.displaySmall?.copyWith(fontFamily: Metinler.fontAdi),
            ),
          ),
        ],
      ),
    );
  }
}

class GruplanmisUrun {
  String urunAdi;
  int toplamAdet;
  String urunResimAdi;
  int sepetYemekId;

  GruplanmisUrun(this.urunAdi, this.urunResimAdi, this.toplamAdet, this.sepetYemekId);
}


//! sepet eski
/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/constants/sayilar.dart';
import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';

class SepetSayfa extends StatefulWidget {
  const SepetSayfa({
    super.key,
  });

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {
  int genelToplam = 0;

  void updateGenelToplam(List<Sepet> sepet) {
    Future.delayed(Duration.zero, () {
      setState(() {
        genelToplam = sepet
            .map((urun) => int.parse(urun.yemek_fiyat) * int.parse(urun.yemek_siparis_adet))
            .reduce((a, b) => a + b);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<SepetSayfaCubit>().sepettekiUrunleriCek("taylan_deneme");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Metinler.sepetimYazi),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SepetSayfaCubit, List<Sepet>>(
              builder: (context, sepet) {
                if (sepet.isNotEmpty) {
                  updateGenelToplam(sepet);
                  return ListView.builder(
                    itemCount: sepet.length,
                    itemBuilder: (context, indeks) {
                      var urun = sepet[indeks];
                      int urunToplam = int.parse(urun.yemek_fiyat) * int.parse(urun.yemek_siparis_adet);
                      genelToplam += urunToplam;
                      return Card(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: context.general.mediaQuery.size.height / 8,
                              height: context.general.mediaQuery.size.width / 4,
                              child: Image.network("${Metinler.temelResimUrl}${urun.yemek_resim_adi}")),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(urun.yemek_adi,
                                    style: const TextStyle(fontFamily: Metinler.fontAdi, fontSize: 20)),
                              ),
                              Text(
                                "Fiyat: ₺${urun.yemek_fiyat}",
                                style: const TextStyle(fontFamily: Metinler.fontAdi, fontSize: 16),
                              ),
                              Text("Adet: ${urun.yemek_siparis_adet}     ",
                                  style: const TextStyle(fontFamily: Metinler.fontAdi, fontSize: 16)),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<SepetSayfaCubit>()
                                        .sepetUrunSil(int.parse(urun.sepet_yemek_id), "taylan_deneme");
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 32,
                                    color: Colors.red,
                                  )),
                              Text("₺$urunToplam",
                                  style:
                                      const TextStyle(fontFamily: Metinler.fontAdi, fontSize: 32, color: Colors.green)),
                            ],
                          )
                        ],
                      ));
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: Sayilar.defaultPad,
            child: Text("Toplam ₺$genelToplam",
                style: context.general.textTheme.displaySmall?.copyWith(fontFamily: Metinler.fontAdi)),
          ),
        ],
      ),
    );
  }
}

 */