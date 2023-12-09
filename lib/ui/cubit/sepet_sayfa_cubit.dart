// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/data/repo/yemekler_dao_repository.dart';

class SepetSayfaCubit extends Cubit<List<Sepet>> {
  SepetSayfaCubit() : super(<Sepet>[]);

  var repo = YemeklerDaoRepository();

  Future<void> sepettekiUrunleriCek(String kullanici_adi) async {
    try {
      var sepetListesi = await repo.sepettekiUrunleriCek(kullanici_adi);
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

  Future<bool> sepetUrunSil(int sepet_yemek_id, String kullanici_adi) async {
    try {
      await repo.sepetUrunSil(sepet_yemek_id, kullanici_adi);
      await sepettekiUrunleriCek(kullanici_adi);
      return true;
    } catch (e) {
      print("Hata oluştu: $e");
      return false;
    }
  }
}


/*
sepet sayfa cubit yedegi

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yemekler_uygulamasi/data/entity/sepet.dart';
import 'package:yemekler_uygulamasi/data/repo/yemekler_dao_repository.dart';

class SepetSayfaCubit extends Cubit<List<Sepet>> {
  SepetSayfaCubit() : super(<Sepet>[]);

  var repo = YemeklerDaoRepository();

  Future<void> sepettekiUrunleriCek(String kullanici_adi) async {
    try {
      var sepetListesi = await repo.sepettekiUrunleriCek(kullanici_adi);
      emit(sepetListesi);
    } catch (e) {
      print("sepet boş geldi");
      emit([]);
    }
  }

  Future<void> sepetUrunSil(int sepet_yemek_id, String kullanici_adi) async {
    await repo.sepetUrunSil(sepet_yemek_id, kullanici_adi);
    await sepettekiUrunleriCek(kullanici_adi);
  }
}

 */