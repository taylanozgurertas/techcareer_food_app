import 'package:yemekler_uygulamasi/data/entity/sepet.dart';

class SepetCevap {
  List<Sepet> sepetListesi;
  int success;

  SepetCevap({required this.sepetListesi, required this.success});

  factory SepetCevap.fromJson(Map<String, dynamic> json) {
    var jsonDizisi = (json["sepet_yemekler"] ?? []) as List;
    List<Sepet> sepetListesi = jsonDizisi.map((jsonNesnesi) => Sepet.fromJson(jsonNesnesi)).toList();
    return SepetCevap(sepetListesi: sepetListesi, success: json["success"] as int);
  }
}
