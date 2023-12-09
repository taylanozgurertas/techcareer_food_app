import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:yemekler_uygulamasi/data/entity/favlanan_urun.dart';
import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/data/entity/sepet_cevap.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler_cevap.dart';
import 'package:yemekler_uygulamasi/data/veritabani_yardimcisi/yardimci.dart';

class YemeklerDaoRepository {
  Future<void> sqliteKaydet(int urun_id, String urun_adi, String urun_resim_adi, String urun_fiyati) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim(); //veritabanı erişim ve kaydetme islemi burada
    var yeniUrun = Map<String, dynamic>();
    yeniUrun["urun_id"] = urun_id;
    yeniUrun["urun_adi"] = urun_adi;
    yeniUrun["urun_resim_adi"] = urun_resim_adi;
    yeniUrun["urun_fiyati"] = urun_fiyati;

    await db.insert("favlananUrun", yeniUrun);
  }

  Future<List<FavlananUrun>> favlananUrunleriYukle() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim(); //veritabanı erisim
    List<Map<String, dynamic>> satirlar = await db.rawQuery("SELECT * FROM favlananUrun"); //sorguyu calistirabiliyoruz
    //her bir satırı bir map olarak bir listeye atıyoruz
    return List.generate(satirlar.length, (index) {
      //tek tek bu listenin tum elemanlari icin Kisiler sınıfından nesne üretiyoruz
      var satir = satirlar[index];
      var urun_id = satir["urun_id"];
      var urun_adi = satir["urun_adi"];
      var urun_resim_adi = satir["urun_resim_adi"];
      var urun_fiyati = satir["urun_fiyati"];
      return FavlananUrun(
          urun_id: urun_id,
          urun_adi: urun_adi,
          urun_resim_adi: urun_resim_adi,
          urun_fiyati: urun_fiyati); //uretilen nesnelerin verileri veritabanından almis oluyoruz yani
    });
  }

  Future<void> sqliteSil(int urun_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim(); //veritabanı erişim ve silme islemi
    await db.delete("favlananUrun", where: 'urun_id = ?', whereArgs: [urun_id]);
  }

  List<Yemekler> parseYemeklerCevap(String cevap) {
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }

  Future<List<Yemekler>> yemekleriYukle() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

  Future<void> sepeteYemekEkle(
      {required String yemek_resim_adi,
      required String yemek_adi,
      required String kullaniciAdi,
      required int adet,
      required int yemek_fiyat,
      required Yemekler yemek}) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    try {
      var veri = {
        "yemek_adi": yemek_adi,
        "yemek_resim_adi": yemek_resim_adi,
        "yemek_fiyat": yemek_fiyat.toString(),
        "yemek_siparis_adet": adet.toString(),
        "kullanici_adi": kullaniciAdi,
      };
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Sepete ürün başariyla eklendi: ${cevap.data.toString()}");
    } catch (hata) {
      print("Hata oluştu: $hata");
    }
  }

  List<Sepet> parseSepetUrunleriCevap(String cevap) {
    return SepetCevap.fromJson(json.decode(cevap)).sepetListesi;
  }

  Future<List<Sepet>> sepettekiUrunleriCek(String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    List<Sepet> hataOlmasiDurumundaList = [];
    try {
      var veri = {"kullanici_adi": kullanici_adi};
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("sepetteki ürünler getirildi: ${cevap.data.toString()}");
      return parseSepetUrunleriCevap(cevap.data.toString());
    } catch (hata) {
      print("Hata oluştu: $hata");
      return hataOlmasiDurumundaList;
    }
  }

  Future<void> sepetUrunSil(int sepet_yemek_id, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var veri = {"sepet_yemek_id": sepet_yemek_id.toString(), "kullanici_adi": kullanici_adi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("yemek basarili bir sekilde silindi ${cevap.data.toString()}");
  }
}
