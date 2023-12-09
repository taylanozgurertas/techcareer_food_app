import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';

class UrunFiyatWidgeti extends StatelessWidget {
  const UrunFiyatWidgeti({
    super.key,
    required this.yemek,
    required this.yaziBuyuklugu,
  });

  final Yemekler yemek;
  final double yaziBuyuklugu;

  @override
  Widget build(BuildContext context) {
    return Text(
      "₺${yemek.yemek_fiyat}",
      style: context.general.textTheme.titleMedium?.copyWith(
        fontFamily: Metinler.fontAdi,
        fontSize: yaziBuyuklugu,
      ),
    );
  }
}
