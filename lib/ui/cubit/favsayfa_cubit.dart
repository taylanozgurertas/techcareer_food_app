import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemekler_uygulamasi/data/entity/favlanan_urun.dart';
import 'package:yemekler_uygulamasi/data/repo/yemekler_dao_repository.dart';

class FavSayfaCubit extends Cubit<List<FavlananUrun>> {
  FavSayfaCubit() : super(<FavlananUrun>[]);

  var krepo = YemeklerDaoRepository();

  Future<void> urunleriYukle() async {
    var liste = await krepo.favlananUrunleriYukle();
    emit(liste);
  }

  Future<void> sqliteKaydet(int urun_id, String urun_adi, String urun_resim_adi, String urun_fiyati) async {
    await krepo.sqliteKaydet(urun_id, urun_adi, urun_resim_adi, urun_fiyati);
  }

  /*
  Future<void> ara(String aramaKelimesi) async{
    var liste = await krepo.ara(aramaKelimesi);
    emit(liste);
  }
   */

  Future<void> sqliteSil(int urun_id) async {
    await krepo.sqliteSil(urun_id);
    urunleriYukle();
  }
}
