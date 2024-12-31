import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class KullaniciVeritabani {
  static final KullaniciVeritabani _veritabani = KullaniciVeritabani._icVeritabani();
  static Database? _db;

  KullaniciVeritabani._icVeritabani();

  factory KullaniciVeritabani() {
    return _veritabani;
  }

  Future<Database> get db async {
    _db ??= await _veritabaniOlustur();
    return _db!;
  }

  Future<Database> _veritabaniOlustur() async {
    String yol = join(await getDatabasesPath(), 'kullanici_veritabani.db');
    return openDatabase(
      yol,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kullanicilar (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kullanici_adi TEXT UNIQUE NOT NULL,
            sifre TEXT NOT NULL,
            isim TEXT NOT NULL,
            soyisim TEXT NOT NULL,
            cinsiyet TEXT NOT NULL,
            hobiler TEXT,
            dogum_tarihi TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE kullanicilar ADD COLUMN dogum_tarihi TEXT');
        }
      },
    );
  }

  Future<void> kullaniciEkle(Map<String, dynamic> kullanici) async {
    final dbClient = await db;
    await dbClient.insert('kullanicilar', kullanici);
  }

  Future<Map<String, dynamic>?> kullaniciKontrol(String kullaniciAdi, String sifre) async {
    final dbClient = await this.db;
    final sonuc = await dbClient.query(
      'kullanicilar',
      where: 'kullanici_adi = ? AND sifre = ?',
      whereArgs: [kullaniciAdi, sifre],
    );
    return sonuc.isNotEmpty ? sonuc.first : null;
  }
  
  /*Future<List<Map<String, dynamic>>> tumKullanicilariGetir() async {
    final dbClient = await this.db;
    return await dbClient.query('kullanicilar');
  }*/

  Future<List<Map<String, dynamic>>> tumKullanicilariGetir() async {
    final dbClient = await this.db;
    // Veritabanından tüm kullanıcıları al
    final result = await dbClient.query('kullanicilar');
  
    // Null olmayanları filtrele
    return result.where((user) => user['sifre'] == null).toList();
  }  
  Future<void> kullaniciSil(int id) async {
    final db = await this.db; 
    await db.delete(
      'kullanicilar',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

