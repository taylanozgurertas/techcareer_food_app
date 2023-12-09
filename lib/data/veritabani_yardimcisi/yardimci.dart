import 'dart:io';
import 'package:flutter/services.dart'; //
import 'package:path/path.dart'; //join metodu icin dosya yolunu belirtmeyi ona gore calismak icin gerekli
import 'package:sqflite/sqflite.dart'; //getDatabasesPath metodunu kullanmak icin gerekli

class VeritabaniYardimcisi {
  static final String veritabaniAdi = "favlananUrunler.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(),
        veritabaniAdi); //databasepathe gidip rehber.sqlite adında bir veritabanı varsa onun pathini ver

    if (await databaseExists(veritabaniYolu)) {
      //databaseExists metodu verilen pathe bakar var mı o veritabanı dosyası orda diye
      print("veritabanı daha önce kopyalanmış");
    } else {
      //yoksa kopyalamamız gerekeceği için burada yapıyoruz o işlemi
      ByteData data = await rootBundle.load("lib/data/sqlite/$veritabaniAdi");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      print("veritabanı kopyalandı");
    }

    return openDatabase(veritabaniYolu);
  }
}
