import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yemekler_uygulamasi/constants/sayilar.dart';
import 'package:yemekler_uygulamasi/ui/views/anasayfa.dart';
import 'package:yemekler_uygulamasi/ui/views/favsayfa.dart';
import 'package:yemekler_uygulamasi/ui/views/sepet_sayfa.dart';

class TabSayfa extends StatefulWidget {
  const TabSayfa({
    super.key,
  });

  @override
  State<TabSayfa> createState() => _TabSayfaState();
}

class _TabSayfaState extends State<TabSayfa> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: Sayilar.crossAxisAyari,
        child: Scaffold(
            body: TabBarView(children: [
              const Anasayfa(),
              FavSayfa(),
            ]),
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: floatingButtonim(),
            bottomNavigationBar: bottomAppBarim()));
  }

  BottomAppBar bottomAppBarim() {
    return const BottomAppBar(
      //color: Renkler.siyahRenk,
      notchMargin: Sayilar.besimBenim,
      shape: CircularNotchedRectangle(),
      child: TabBar(
        tabs: [
          Tab(child: Icon(Icons.home)),
          Tab(
              child: Icon(Icons.favorite_rounded))
        ],
        //labelColor: Renkler.beyazRenk,
        //unselectedLabelColor: Renkler.beyazRenk,
        //indicatorColor: Renkler.beyazRenk,
      ),
    );
  }

  FloatingActionButton floatingButtonim() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SepetSayfa(),
            ));
      },
      //foregroundColor: Renkler.beyazRenk,
      //backgroundColor: Renkler.siyahRenk,
      child: const Icon(Icons.shopping_cart),
    );
  }
}
