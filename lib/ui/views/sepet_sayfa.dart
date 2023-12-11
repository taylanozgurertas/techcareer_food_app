import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/constants/sayilar.dart';
import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/services/auth_service.dart';
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

        for (var urun in sepet) {
          var urunAdi = urun.yemek_adi;
          var urunResimAdi = urun.yemek_resim_adi;
          var sepetYemekId = urun.sepet_yemek_id;
          var urunFiyati = urun.yemek_fiyat;

          var gruplanmisUrun = gruplanmisUrunler.putIfAbsent(
            urunAdi,
            () => GruplanmisUrun(urunAdi, urunResimAdi, Sayilar.kZeros,
                int.parse(sepetYemekId), urunFiyati),
          );

          int adet = int.parse(urun.yemek_siparis_adet);
          gruplanmisUrun.toplamAdet += adet;

          yeniGenelToplam += int.parse(urun.yemek_fiyat) * adet;
        }

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
    var email = AuthService.getSavedEmail();
    
    context.read<SepetSayfaCubit>().sepettekiUrunleriCek(email ?? "taylan");
  }

  List<GruplanmisUrun> groupedSepet = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Metinler.sepetimYazi,
          style: TextStyle(fontFamily: Metinler.fontAdi),
        ),
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
                              ? ClipOval(
                                  child: Image(
                                    image: NetworkImage(
                                      '${Metinler.temelResimUrl}${gruplanmisUrun.urunResimAdi}',
                                    ),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Resim yüklendiğinde
                                        return child;
                                      } else {
                                        // Resim hala yükleniyorsa, CircularProgress göster
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      // Hata durumunda alternatif bir resim göstermek için errorBuilder kullanımı
                                      return const Center(
                                        child: Text('Hata'),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          title: Text(gruplanmisUrun.urunAdi,
                              style: context.general.textTheme.titleLarge),
                          subtitle: Row(
                            children: [
                              Text(
                                  "${Metinler.adet}${gruplanmisUrun.toplamAdet} | Fiyat: ₺${gruplanmisUrun.urunFiyati}",
                                  style: context.general.textTheme.labelLarge
                                      ?.copyWith(fontFamily: Metinler.fontAdi)),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Builder(
                                builder: (context) {
                                  try {
                                    var urun = sepet.firstWhere((urun) =>
                                        urun.yemek_adi ==
                                        gruplanmisUrun.urunAdi);
                                    double urunFiyat =
                                        double.parse(urun.yemek_fiyat);
                                    double toplamFiyat =
                                        gruplanmisUrun.toplamAdet * urunFiyat;

                                    return Text(
                                        "${Metinler.toplamT}$toplamFiyat",
                                        style: context
                                            .general.textTheme.labelLarge
                                            ?.copyWith(
                                                fontFamily: Metinler.fontAdi));
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
                                  var email = AuthService.getSavedEmail();
                                  context
                                      .read<SepetSayfaCubit>()
                                      .sepetUrunSil(
                                          gruplanmisUrun.sepetYemekId, "$email")
                                      .then((silindi) {
                                    if (silindi) {
                                      //! Ürün başarıyla silindi, sepeti güncelle
                                      context
                                          .read<SepetSayfaCubit>()
                                          .sepettekiUrunleriCek("$email");
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
              style: context.general.textTheme.headlineMedium
                  ?.copyWith(fontFamily: Metinler.fontAdi),
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
  String urunFiyati;

  GruplanmisUrun(this.urunAdi, this.urunResimAdi, this.toplamAdet,
      this.sepetYemekId, this.urunFiyati);
}
