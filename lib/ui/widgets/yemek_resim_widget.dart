import 'package:flutter/material.dart';
import 'package:yemekler_uygulamasi/constants/metinler.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';

class YemekResimWidget extends StatefulWidget {
  const YemekResimWidget({
    super.key,
    required this.yemek,
  });

  final Yemekler yemek;

  @override
  State<YemekResimWidget> createState() => _YemekResimWidgetState();
}

class _YemekResimWidgetState extends State<YemekResimWidget> {
  bool yemekBozuk = false;

  @override
  void initState() {
    super.initState();
    if (widget.yemek.yemek_adi == "Lazanya" || widget.yemek.yemek_adi == "Pizza") {
      setState(() {
        yemekBozuk = false;
      });
    } else {
      setState(() {
        yemekBozuk = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return yemekBozuk
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '${Metinler.temelResimUrl}${widget.yemek.yemek_resim_adi}',
                ),
                fit: BoxFit.contain,
              ),
            ),
          )
        : Center(
            child: ClipOval(
              child: Image.network(
                '${Metinler.temelResimUrl}${widget.yemek.yemek_resim_adi}',
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}


/*
Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                '${Metinler.temelResimUrl}${widget.yemek.yemek_resim_adi}',
                fit: BoxFit.cover,
              ),
            ),
          );
 */
