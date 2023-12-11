// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/data/repo/yemekler_dao_repository.dart';

class SepetSayfaCubit extends Cubit<List<Sepet>> {
  SepetSayfaCubit() : super(<Sepet>[]);

  var repo = YemeklerDaoRepository();

  Future<void> sepettekiUrunleriCek(String kullaniciAdi) async {
    try {
      var sepetListesi = await repo.sepettekiUrunleriCek(kullaniciAdi);
      if (sepetListesi.isNotEmpty) {
        emit(sepetListesi);
      } else {
        print("Sepet boş geldi");
        emit([]);
      }
    } catch (e) {
      print("Hata oluştu: $e");
      print("Sepet boş geldi");
      emit([]);
    }
  }

  Future<bool> sepetUrunSil(int sepetYemekId, String kullaniciAdi) async {
    try {
      await repo.sepetUrunSil(sepetYemekId, kullaniciAdi);
      await sepettekiUrunleriCek(kullaniciAdi);
      return true;
    } catch (e) {
      print("Hata oluştu: $e");
      return false;
    }
  }
}
