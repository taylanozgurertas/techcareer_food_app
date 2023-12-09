import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';
import 'package:yemekler_uygulamasi/data/repo/yemekler_dao_repository.dart';

class UrunBilgileri {
  int secilenAdetSayisi;
  int toplamFiyat;

  UrunBilgileri({required this.secilenAdetSayisi, required this.toplamFiyat});
}

class DetaySayfaCubit extends Cubit<UrunBilgileri> {
  DetaySayfaCubit() : super(UrunBilgileri(secilenAdetSayisi: 0, toplamFiyat: 0));

  var repo = YemeklerDaoRepository();

  int urunFiyat = 0;

  Future<void> sepeteEkle(Yemekler yemek) async {
    var kullaniciAdi = "taylan_deneme";
    if (state.secilenAdetSayisi == 0) {
      print("0 adet satin alinmamis demektir");
    } else {
      await repo.sepeteYemekEkle(
          yemek: yemek,
          kullaniciAdi: kullaniciAdi,
          adet: state.secilenAdetSayisi,
          yemek_resim_adi: yemek.yemek_resim_adi,
          yemek_adi: yemek.yemek_adi,
          yemek_fiyat: int.parse(yemek.yemek_fiyat));
    }
  }

  void urunFiyatiniYollaIslemSoyle(int urunFiyati, int islem) {
    if (islem == 1) {
      print("arttir seçildi");
      urunFiyat = urunFiyati;
      arttir();
    } else {
      print("azalt seçildi");
      urunFiyat = urunFiyati;
      azalt();
    }
    urunFiyati = urunFiyati;
  }

  void degerleriSifirla() {
    state.toplamFiyat = 0;
    state.secilenAdetSayisi = 0;
  }

  void arttir() {
    state.secilenAdetSayisi += 1;
    state.toplamFiyat = state.secilenAdetSayisi * urunFiyat;

    emit(UrunBilgileri(secilenAdetSayisi: state.secilenAdetSayisi, toplamFiyat: state.toplamFiyat));
  }

  void azalt() {
    if (state.secilenAdetSayisi <= 0) {
      print("adet 0'dan kucuk olamaz");
    } else {
      state.secilenAdetSayisi -= 1;
      state.toplamFiyat = state.secilenAdetSayisi * urunFiyat;
      emit(UrunBilgileri(secilenAdetSayisi: state.secilenAdetSayisi, toplamFiyat: state.toplamFiyat));
    }
  }
}
