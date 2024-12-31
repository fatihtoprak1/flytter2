import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';


class VeriTabani {
  static final VeriTabani _ornek = VeriTabani._icsel();
  static Database? _veritabani;

  factory VeriTabani() {
    return _ornek;
  }

  VeriTabani._icsel();

  Future<Database> get veritabani async {
    if (_veritabani != null) return _veritabani!;
    _veritabani = await _veritabaniOlustur();
    return _veritabani!;
  }

  Future<Database> _veritabaniOlustur() async {
    String yol = join(await getDatabasesPath(), 'gelir_gider.db');
    return await openDatabase(
      yol,
      version: 2,
      onCreate: (db, version) async {
        // Kullanıcılar tablosu
        await db.execute('''
          CREATE TABLE kullanicilar (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              kullanici_adi TEXT UNIQUE NOT NULL,
              parola TEXT NOT NULL,
              firma_adi TEXT,
              profil_resmi BLOB
          )
        ''');

        // İşlemler tablosu
        await db.execute('''
          CREATE TABLE islemler (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              kullanici_id INTEGER,
              tarih TEXT,
              tutar REAL,
              aciklama TEXT,
              tur TEXT CHECK(tur IN ('gelir', 'gider')),
              FOREIGN KEY(kullanici_id) REFERENCES kullanicilar(id)
          )
        ''');

        // Gelir-Gider tablosu
        await db.execute('''
          CREATE TABLE gelir_gider (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              tarih TEXT NOT NULL,
              tur TEXT NOT NULL,
              miktar REAL NOT NULL,
              aciklama TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE gelir_gider ADD COLUMN yeni_kolon TEXT
          ''');
        }
      },
    );
  }


  Future<void> veritabaniSil() async {
    String dbPath = join(await getDatabasesPath(), 'gelir_gider.db');
    try {
      print("Veritabanı dosyasının yolu: $dbPath");
      if (_veritabani != null) {
        await _veritabani!.close();
        print("Veritabanı bağlantısı kapatıldı.");
      }

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
        print("Veritabanı başarıyla silindi.");
      } else {
        print("Veritabanı dosyası bulunamadı.");
      }
    } catch (e) {
      print("Veritabanı silinirken hata oluştu: $e");
    }
  }
}


/*class VeriTabani {
  static final VeriTabani _ornek = VeriTabani._icsel();
  static Database? _veritabani;

  factory VeriTabani() {
    return _ornek;
  }

  VeriTabani._icsel();

  Future<Database> get veritabani async {
    if (_veritabani != null) return _veritabani!;
    _veritabani = await _veritabaniOlustur();
    return _veritabani!;
  }

  Future<Database> _veritabaniOlustur() async {
  String yol = join(await getDatabasesPath(), 'gelir_gider.db');
  return await openDatabase(
    yol,
    version: 2, // Veritabanı sürümünü 2'ye çıkarıyoruz
    onCreate: (db, version) async {
      // Kullanıcılar tablosu
      await db.execute('''
        CREATE TABLE kullanicilar (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kullanici_adi TEXT UNIQUE NOT NULL,
            parola TEXT NOT NULL,
            firma_adi TEXT,
            profil_resmi BLOB
        )
      ''');

      // İşlemler tablosu
      await db.execute('''
        CREATE TABLE islemler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kullanici_id INTEGER,
            tarih TEXT,
            tutar REAL,
            aciklama TEXT,
            tur TEXT CHECK(tur IN ('gelir', 'gider')),
            FOREIGN KEY(kullanici_id) REFERENCES kullanicilar(id)
        )
      ''');

      // Gelir-Gider tablosu
      await db.execute('''
        CREATE TABLE gelir_gider (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tarih TEXT NOT NULL,
            tur TEXT NOT NULL,
            miktar REAL NOT NULL,
            aciklama TEXT
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          ALTER TABLE gelir_gider ADD COLUMN yeni_kolon TEXT
        ''');
      }
    },
  );
}
}*/