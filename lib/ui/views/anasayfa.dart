import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/constants/renkler.dart';
import 'package:yemekler_uygulamasi/constants/sayilar.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';
import 'package:yemekler_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:yemekler_uygulamasi/ui/cubit/favsayfa_cubit.dart';
import 'package:yemekler_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/ui/views/favsayfa.dart';
import 'package:yemekler_uygulamasi/ui/views/sepet_sayfa.dart';
import 'package:yemekler_uygulamasi/ui/widgets/fiyat_text_widget.dart';
import 'package:yemekler_uygulamasi/ui/widgets/ozel_appbar_icon_widget.dart';
import 'package:yemekler_uygulamasi/ui/widgets/yemek_adi_widget.dart';
import 'package:yemekler_uygulamasi/ui/widgets/yemek_resim_widget.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with TickerProviderStateMixin {
  //!gerekli olanlar tanimlandi
  final ScrollController _scrollController = ScrollController();
  var scrollBilgim = false;
  var favlanmisMi = false;
  final Map<int, AnimationController> _animationControllers = {};
  List<bool> favDurumListesi = List.generate(Sayilar.favlanilabilirUzunluk, (index) => false);

  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().yemekleriYukle(); //!cubit calistirilmasi
    scrollKontrolcusuListener(); //!scrollkontrolcusu baslatildi
  }

//!scrollKontrolcu ufak logic
  void scrollKontrolcusuListener() {
    _scrollController.addListener(() {
      scrollLogicListenerIcerik();
    });
  }

//!scrollKontrolLogic Icerigi
  void scrollLogicListenerIcerik() {
    if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      setState(() {
        scrollBilgim = false;
      });
    } else {
      setState(() {
        scrollBilgim = true;
      });
    }
  }

  //!ozelappbar widgeti kullanimi
  List<Widget>? actionsAppBarList = [
    OzelAppBarIcon(
      gidilecekSayfa: SepetSayfa(),
      icon: const Icon(Icons.account_box),
    ),
    OzelAppBarIcon(
      gidilecekSayfa: FavSayfa(),
      icon: const Icon(
        Icons.favorite,
      ),
    ),
    OzelAppBarIcon(
      gidilecekSayfa: SepetSayfa(),
      icon: const Icon(Icons.search),
    ),
  ];

//!dispose islemleri
  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: anaSayfaAppBar(context),
      body: Column(
        children: [
          ustGorunmezBosluk(),
          animasyonluResim(context),
          Expanded(
            child: BlocBuilder<AnasayfaCubit, List<Yemekler>>(
              //!BlocBuilder kullanimi
              builder: (context, liste) {
                if (liste.isNotEmpty) {
                  return GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Sayilar.crossAxisAyari),
                    itemCount: liste.length,
                    itemBuilder: (context, indeks) {
                      animasyonKontrolBasitLogic(indeks);
                      var yemek = liste[indeks]; //! yemek listesinden indekse gore yemek cekildi
                      return GestureDetector(
                        onTap: () {
                          cardaTiklandiBasitLogic(context, yemek);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            YemekAdiWidget(
                              yemek: yemek,
                              yaziBuyuklugu: 16,
                            ),
                            Padding(
                              padding: context.padding.low,
                              child: Column(
                                children: [
                                  Stack(alignment: Alignment.bottomRight, children: [
                                    SizedBox(
                                      height: context.general.mediaQuery.size.width / Sayilar.resimYukseklik,
                                      width: context.general.mediaQuery.size.height / Sayilar.resimGenislik,
                                      child: Card(
                                        child: YemekResimWidget(yemek: yemek),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Renkler.favDiger, borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            var inteCevrilenId = int.parse(yemek.yemek_id);

                                            favDurumKontrolcusu(indeks, inteCevrilenId, yemek);
                                          });
                                        },
                                        child: lottieBegeni(context, indeks),
                                      ),
                                    ),
                                  ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: context.padding.onlyTopLow,
                                        child: UrunFiyatWidgeti(
                                          yemek: yemek,
                                          yaziBuyuklugu: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

//!anasayfaya ozel ufak appbar
  AppBar anaSayfaAppBar(BuildContext context) {
    return AppBar(
      shadowColor: Renkler.siyahRenk,
      elevation: Sayilar.elevationGenel,
      centerTitle: false,
      title: SizedBox(width: context.general.mediaQuery.size.height / Sayilar.on, child: ustUfakLogo()),
      actions: actionsAppBarList,
    );
  }

//!anasayfaya ozel ufak logo
  Image ustUfakLogo() {
    return Image.asset("${Metinler.temelAssetYolu}${Metinler.tarfoodResim}",
        fit: BoxFit.contain, color: Renkler.beyazRenk);
  }

//!ust gorunmez ana sayfaya ozel bosluk
  Visibility ustGorunmezBosluk() {
    return Visibility(
        visible: scrollBilgim,
        child: const SizedBox(
          height: Sayilar.basBosluk,
        ));
  }

//!anasayfaya ozel animasyonlu resim kullanimi
  AnimatedContainer animasyonluResim(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: context.duration.durationLow,
      height: scrollBilgim ? Sayilar.kZero : context.general.mediaQuery.size.width / Sayilar.anaSayfaHesabi,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: context.general.mediaQuery.size.width,
          child: Padding(
            padding: context.padding.low,
            child: ClipRRect(
              borderRadius: context.border.highBorderRadius,
              child: Image.asset(
                "${Metinler.temelAssetYolu}${Metinler.anaResimYazi}",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

//!animasyon kontrolu icin yazdigim logic
  void animasyonKontrolBasitLogic(int indeks) {
    if (!_animationControllers.containsKey(indeks)) {
      _animationControllers[indeks] = AnimationController(
        vsync: this,
        duration: Sayilar.birSaniyelik,
      );
    }
  }

//!carda tiklandiginda yazdigim basit logic
  void cardaTiklandiBasitLogic(BuildContext context, Yemekler yemek) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetaySayfa(yemek: yemek),
        ));
  }

//!lottie resmi ana sayfaya ozel
  LottieBuilder lottieBegeni(BuildContext context, int indeks) {
    return Lottie.asset(
      height: context.general.mediaQuery.size.width / Sayilar.lottieBuyukluk,
      Metinler.lottie,
      controller: _animationControllers[indeks],
    );
  }

//!lottie icin kullanilan favlama icin yazdigim basit logic
  void favDurumKontrolcusu(int indeks, int cevrilenId, Yemekler yemek) {
    favDurumListesi[indeks] = !favDurumListesi[indeks];

    if (favDurumListesi[indeks]) {
      _animationControllers[indeks]!.forward();
      context.read<FavSayfaCubit>().sqliteKaydet(cevrilenId, yemek.yemek_adi, yemek.yemek_resim_adi, yemek.yemek_fiyat);
    } else {
      _animationControllers[indeks]!.reverse().whenComplete(() {
        context.read<FavSayfaCubit>().sqliteSil(int.parse(yemek.yemek_id));
        _animationControllers[indeks]!.reset();
      });
    }
  }

  Divider divider() {
    return const Divider(
      thickness: Sayilar.dividerKalinligi,
      color: Renkler.gri,
    );
  }
}
