import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:son_odev_6/veritabani.dart';

class AyarlarEkrani extends StatefulWidget {
  @override
  _AyarlarEkraniState createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  final _formKey = GlobalKey<FormState>();
  String? kullaniciAdi;
  String? parola;
  String? firmaAdi;
  File? profilResmi;

  bool _kullaniciAdiDegistir = false;
  bool _parolaDegistir = false;
  bool _firmaAdiDegistir = false;
  int? _kullaniciId; 
  bool _isDeleting = false;

  Future<void> _silVeritabani() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await VeriTabani().veritabaniSil();

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("Veritabanı başarıyla silindi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("Veritabanı silinirken hata oluştu: $e")),
      );
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  Future<void> bilgileriYukle() async {
    final veritabani = await VeriTabani().veritabani;
    final sonuc = await veritabani.query('kullanicilar', limit: 1); // Sadece bir kullanıcıyı alıyoruz

    if (sonuc.isNotEmpty) {
      final veri = sonuc.first;
      setState(() {
        _kullaniciId = veri['id'] as int?; // ID'yi alıyoruz
        kullaniciAdi = veri['kullanici_adi'] as String?;
        parola = veri['parola'] as String?;
        firmaAdi = veri['firma_adi'] as String?;
        profilResmi = veri['profil_resmi'] != null
            ? File(veri['profil_resmi'] as String)
            : null;
      });
    }
  }

  Future<void> profilResmiSec() async {
    final picker = ImagePicker();
    final secilen = await picker.pickImage(source: ImageSource.gallery);

    if (secilen != null) {
      setState(() {
        profilResmi = File(secilen.path);
      });
    }
  }

  Future<void> bilgileriKaydet() async {
  if (_kullaniciId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kullanıcı bilgileri alınamadı.')),
    );
    return;
  }

  _formKey.currentState!.save(); 
  final veritabani = await VeriTabani().veritabani;

  final mevcutVeri = await veritabani.query(
    'kullanicilar',
    where: 'id = ?',
    whereArgs: [_kullaniciId], 
  );

  if (mevcutVeri.isNotEmpty) {
    final mevcutKullanici = mevcutVeri.first;

    final guncellenmisVeriler = {
      'kullanici_adi': _kullaniciAdiDegistir ? kullaniciAdi : mevcutKullanici['kullanici_adi'],
      'parola': _parolaDegistir ? parola : mevcutKullanici['parola'],
      'firma_adi': _firmaAdiDegistir ? firmaAdi : mevcutKullanici['firma_adi'],
      'profil_resmi': profilResmi?.path ?? mevcutKullanici['profil_resmi'],
    };

    await veritabani.update(
      'kullanicilar',
      guncellenmisVeriler,
      where: 'id = ?',  
      whereArgs: [_kullaniciId], 
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bilgiler başarıyla güncellendi!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kullanıcı bulunamadı!')),
    );
  }
}

  @override
  void initState() {
    super.initState();
    bilgileriYukle(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayarlar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: profilResmiSec,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profilResmi != null
                      ? FileImage(profilResmi!)
                      : null,
                  child: profilResmi == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: kullaniciAdi,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  hintText: kullaniciAdi ?? 'Mevcut kullanıcı adı',
                ),
                enabled: _kullaniciAdiDegistir,
                onSaved: (value) => kullaniciAdi = value,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _kullaniciAdiDegistir = !_kullaniciAdiDegistir;
                  });
                },
                child: Text(_kullaniciAdiDegistir ? 'Değiştirme' : 'Değiştir'),
              ),

              TextFormField(
                initialValue: parola,
                decoration: InputDecoration(
                  labelText: 'Parola',
                  hintText: parola ?? 'Mevcut parola',
                ),
                obscureText: true,
                enabled: _parolaDegistir,
                onSaved: (value) => parola = value,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _parolaDegistir = !_parolaDegistir;
                  });
                },
                child: Text(_parolaDegistir ? 'Değiştirme' : 'Değiştir'),
              ),

              TextFormField(
                initialValue: firmaAdi,
                decoration: InputDecoration(
                  labelText: 'Firma Adı',
                  hintText: firmaAdi ?? 'Mevcut firma adı',
                ),
                enabled: _firmaAdiDegistir,
                onSaved: (value) => firmaAdi = value,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _firmaAdiDegistir = !_firmaAdiDegistir;
                  });
                },
                child: Text(_firmaAdiDegistir ? 'Değiştirme' : 'Değiştir'),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: bilgileriKaydet,
                child: Text('Kaydet'),
              ),
              ElevatedButton(
                onPressed: _isDeleting ? null : _silVeritabani,
                child: _isDeleting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Veritabanını Sil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*class AyarlarEkrani extends StatefulWidget {
  @override
  _AyarlarEkraniState createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  final _formKey = GlobalKey<FormState>();
  String? kullaniciAdi;
  String? parola;
  String? firmaAdi;
  File? profilResmi;

  bool _kullaniciAdiDegistir = false;
  bool _parolaDegistir = false;
  bool _firmaAdiDegistir = false;
  int? _kullaniciId; // Kullanıcı ID'sini burada saklıyoruz

  // Kullanıcı bilgilerini yüklerken ID'yi de alıyoruz
  Future<void> bilgileriYukle() async {
    final veritabani = await VeriTabani().veritabani;
    final sonuc = await veritabani.query('kullanicilar', limit: 1); // Sadece bir kullanıcıyı alıyoruz

    if (sonuc.isNotEmpty) {
      final veri = sonuc.first;
      setState(() {
        _kullaniciId = veri['id'] as int?; // ID'yi alıyoruz
        kullaniciAdi = veri['kullanici_adi'] as String?;
        parola = veri['parola'] as String?;
        firmaAdi = veri['firma_adi'] as String?;
        profilResmi = veri['profil_resmi'] != null
            ? File(veri['profil_resmi'] as String)
            : null;
      });
    }
  }

  // Profil resmi seçmek için galeri açma
  Future<void> profilResmiSec() async {
    final picker = ImagePicker();
    final secilen = await picker.pickImage(source: ImageSource.gallery);

    if (secilen != null) {
      setState(() {
        profilResmi = File(secilen.path);
      });
    }
  }

  // Kullanıcı bilgilerini veritabanına kaydetme
  Future<void> bilgileriKaydet() async {
  if (_kullaniciId == null) {
    // Eğer kullanıcı ID'si alınmamışsa, işlem yapılmasın
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kullanıcı bilgileri alınamadı.')),
    );
    return;
  }

  _formKey.currentState!.save();

  final veritabani = await VeriTabani().veritabani;

  // Mevcut kullanıcı verilerini alalım
  final mevcutVeri = await veritabani.query('kullanicilar', where: 'id = ?', whereArgs: [_kullaniciId]);

  if (mevcutVeri.isNotEmpty) {
    final mevcutKullanici = mevcutVeri.first;

    // Değiştirilen verileri tutacağız, eğer boşsa mevcut veriyi koruyacağız
    final guncellenmisVeriler = {
      'kullanici_adi': _kullaniciAdiDegistir ? kullaniciAdi : mevcutKullanici['kullanici_adi'],
      'parola': _parolaDegistir ? parola : mevcutKullanici['parola'],
      'firma_adi': _firmaAdiDegistir ? firmaAdi : mevcutKullanici['firma_adi'],
      'profil_resmi': profilResmi?.path ?? mevcutKullanici['profil_resmi'],
    };

    // Veriyi güncelleme
    await veritabani.update(
      'kullanicilar',
      guncellenmisVeriler,
      where: 'id = ?',
      whereArgs: [_kullaniciId], // Dinamik kullanıcı ID'si
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bilgiler başarıyla güncellendi!')),
    );
  }
}

  /*Future<void> bilgileriKaydet() async {
    _formKey.currentState!.save();

    final veritabani = await VeriTabani().veritabani;

    // Mevcut kullanıcı verilerini alalım
    final mevcutVeri = await veritabani.query('kullanicilar', where: 'id = ?', whereArgs: [1]);

    if (mevcutVeri.isNotEmpty) {
      final mevcutKullanici = mevcutVeri.first;

      // Değiştirilen verileri tutacağız, eğer boşsa mevcut veriyi koruyacağız
      final guncellenmisVeriler = {
        'kullanici_adi': _kullaniciAdiDegistir ? kullaniciAdi : mevcutKullanici['kullanici_adi'],
        'parola': _parolaDegistir ? parola : mevcutKullanici['parola'],
        'firma_adi': _firmaAdiDegistir ? firmaAdi : mevcutKullanici['firma_adi'],
        'profil_resmi': profilResmi?.path ?? mevcutKullanici['profil_resmi'],
      };

      // Veriyi güncelleme
      await veritabani.update(
        'kullanicilar',
        guncellenmisVeriler,
        where: 'id = ?',
        whereArgs: [1], // Tek bir kullanıcı için
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bilgiler başarıyla güncellendi!')),
      );
    }
  }*/

  @override
  void initState() {
    super.initState();
    bilgileriYukle(); // Sayfa açıldığında bilgileri yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayarlar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profil resmini seçmek için alan
              GestureDetector(
                onTap: profilResmiSec,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profilResmi != null
                      ? FileImage(profilResmi!)
                      : null,
                  child: profilResmi == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 20),

              // Kullanıcı adı kısmı
              TextFormField(
                initialValue: kullaniciAdi,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  hintText: kullaniciAdi ?? 'Mevcut kullanıcı adı',
                ),
                enabled: _kullaniciAdiDegistir,
                onSaved: (value) => kullaniciAdi = value,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _kullaniciAdiDegistir = !_kullaniciAdiDegistir;
                  });
                },
                child: Text(_kullaniciAdiDegistir ? 'Değiştirme' : 'Değiştir'),
              ),

              // Parola kısmı
              TextFormField(
                initialValue: parola,
                decoration: InputDecoration(
                  labelText: 'Parola',
                  hintText: parola ?? 'Mevcut parola',
                ),
                obscureText: true,
                enabled: _parolaDegistir,
                onSaved: (value) => parola = value,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _parolaDegistir = !_parolaDegistir;
                  });
                },
                child: Text(_parolaDegistir ? 'Değiştirme' : 'Değiştir'),
              ),

              // Firma adı kısmı
              TextFormField(
                initialValue: firmaAdi,
                decoration: InputDecoration(
                  labelText: 'Firma Adı',
                  hintText: firmaAdi ?? 'Mevcut firma adı',
                ),
                enabled: _firmaAdiDegistir,
                onSaved: (value) => firmaAdi = value,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _firmaAdiDegistir = !_firmaAdiDegistir;
                  });
                },
                child: Text(_firmaAdiDegistir ? 'Değiştirme' : 'Değiştir'),
              ),

              SizedBox(height: 20),

              // Kaydet butonu
              ElevatedButton(
                onPressed: bilgileriKaydet,
                child: Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/