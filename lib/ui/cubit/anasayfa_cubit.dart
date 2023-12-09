import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemekler_uygulamasi/data/entity/yemekler.dart';
import 'package:yemekler_uygulamasi/data/repo/yemekler_dao_repository.dart';

class AnasayfaCubit extends Cubit<List<Yemekler>> {
  AnasayfaCubit() : super([]);
  var repo = YemeklerDaoRepository();

  Future<void> yemekleriYukle() async {
    var liste = await repo.yemekleriYukle();
    emit(liste);
  }
}
