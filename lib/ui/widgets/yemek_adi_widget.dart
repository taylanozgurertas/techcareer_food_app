import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/constants/renkler.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';

class YemekAdiWidget extends StatelessWidget {
  const YemekAdiWidget({super.key, required this.yemek, required this.yaziBuyuklugu});

  final Yemekler yemek;
  final double yaziBuyuklugu;

  @override
  Widget build(BuildContext context) {
    return Text(
      yemek.yemek_adi,
      style: context.general.textTheme.bodyMedium
          ?.copyWith(fontSize: yaziBuyuklugu, fontFamily: Metinler.fontAdi, color: Renkler.beyazRenk),
    );
  }
}
