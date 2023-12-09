import 'package:flutter/material.dart';
import 'package:yemekler_uygulamasi/constants/renkler.dart';

class OzelAppBarIcon extends StatefulWidget {
  final StatefulWidget gidilecekSayfa;
  final Icon icon;

  const OzelAppBarIcon({super.key, required this.gidilecekSayfa, required this.icon});

  @override
  State<OzelAppBarIcon> createState() => _OzelAppBarIconState();
}

class _OzelAppBarIconState extends State<OzelAppBarIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.gidilecekSayfa,
            ));
      },
      icon: widget.icon,
      color: Renkler.beyazRenk,
    );
  }
}
