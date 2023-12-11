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

  Future<void> sqliteKaydet(int urunId, String urunAdi, String urunResimAdi,
      String urunFiyati) async {
    await krepo.sqliteKaydet(urunId, urunAdi, urunResimAdi, urunFiyati);
  }

  Future<void> sqliteSil(int urunId) async {
    await krepo.sqliteSil(urunId);
    urunleriYukle();
  }
}
