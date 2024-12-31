import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:son_odev_6/ayarlar.dart';
import 'package:son_odev_6/gelir_giris.dart';
import 'package:son_odev_6/gelir_hesap.dart';
import 'package:son_odev_6/veritabani.dart';

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _formKey = GlobalKey<FormState>();
  String? kullaniciAdi;
  String? parola;

void girisYap() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final veritabani = await VeriTabani().veritabani;

    final sonuc = await veritabani.query(
      'kullanicilar',
      where: 'kullanici_adi = ? AND parola = ?',
      whereArgs: [kullaniciAdi, parola],
    );

    if (sonuc.isNotEmpty) {
      final kullanici = sonuc.first;

      // Kullanıcı bilgilerini al ve tür dönüşümü yap
      final String kullaniciAdiDb = kullanici['kullanici_adi'] as String;
      final String firmaAdiDb = kullanici['firma_adi'] as String;

      // Profil resmi için tür dönüşümü
      Uint8List? profilResmi;
      if (kullanici['profil_resmi'] != null) {
        profilResmi = Uint8List.fromList(kullanici['profil_resmi'] as List<int>);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HosgeldinizEkrani(
            kullaniciAdi: kullaniciAdiDb,
            firmaAdi: firmaAdiDb,
            profilResmi: profilResmi,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı adı veya parola hatalı!')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (value) =>
                    value!.isEmpty ? 'Kullanıcı adı zorunludur!' : null,
                onSaved: (value) => kullaniciAdi = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Parola'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Parola zorunludur!' : null,
                onSaved: (value) => parola = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: girisYap,
                child: Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HosgeldinizEkrani extends StatefulWidget {
  final String kullaniciAdi;
  final String firmaAdi;
  final Uint8List? profilResmi;

  HosgeldinizEkrani({
    required this.kullaniciAdi,
    required this.firmaAdi,
    this.profilResmi,
  });

  @override
  State<HosgeldinizEkrani> createState() => _HosgeldinizEkraniState();
}

class _HosgeldinizEkraniState extends State<HosgeldinizEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawer(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GelirGiderGirisiEkrani(),
                ),
              );
            },
            child: Text("Gelir Gider Giriş"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GelirGiderHesaplamaEkrani(),
                ),
              );
            },
            child: Text("Gelir Gider Hesaplama"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AyarlarEkrani(),
                ),
              );
            },
            child: Text("Ayarlar"),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("HOŞ GELDİNİZ!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilResmiBuyutulmusEkran(
                    profilResmi: widget.profilResmi,
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'profile-image',
              child: CircleAvatar(
                radius: 50,
                backgroundImage: widget.profilResmi != null
                    ? MemoryImage(widget.profilResmi!)
                    : AssetImage('assets/placeholder.png') as ImageProvider,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Merhaba, ${widget.kullaniciAdi.toUpperCase()}!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Firma Adı: "),
              Text(
                widget.firmaAdi.isNotEmpty
                    ? widget.firmaAdi
                    : "Firma adı belirtilmedi.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ProfilResmiBuyutulmusEkran extends StatelessWidget {
  final Uint8List? profilResmi;

  ProfilResmiBuyutulmusEkran({this.profilResmi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: 'profile-image',
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              radius: 150,
              backgroundImage: profilResmi != null
                  ? MemoryImage(profilResmi!)
                  : AssetImage('assets/placeholder.png') as ImageProvider,
            ),
          ),
        ),
      ),
    );
  }
}

/*class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _formKey = GlobalKey<FormState>();
  String? kullaniciAdi;
  String? parola;

  void girisYap() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final veritabani = await VeriTabani().veritabani;

      final sonuc = await veritabani.query(
        'kullanicilar',
        where: 'kullanici_adi = ? AND parola = ?',
        whereArgs: [kullaniciAdi, parola],
      );

      if (sonuc.isNotEmpty) {
        final kullanici = sonuc.first;

        // Tür dönüşümü
        final String kullaniciAdiDb = kullanici['kullanici_adi'] as String;
        final String firmaAdiDb = kullanici['firma_adi'] as String;
        
        // Profil resmi, eğer varsa Uint8List türüne dönüştürülür.
        Uint8List? profilResmi;
        if (kullanici['profil_resmi'] != null) {
          profilResmi = (kullanici['profil_resmi'] as Uint8List);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HosgeldinizEkrani(
              kullaniciAdi: kullaniciAdiDb,
              firmaAdi: firmaAdiDb,
              profilResmi: profilResmi,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı adı veya parola hatalı!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (value) =>
                    value!.isEmpty ? 'Kullanıcı adı zorunludur!' : null,
                onSaved: (value) => kullaniciAdi = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Parola'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Parola zorunludur!' : null,
                onSaved: (value) => parola = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: girisYap,
                child: Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HosgeldinizEkrani extends StatefulWidget {
  final String kullaniciAdi;
  final String firmaAdi;
  final Uint8List? profilResmi;

  HosgeldinizEkrani({
    required this.kullaniciAdi,
    required this.firmaAdi,
    this.profilResmi,
  });

  @override
  State<HosgeldinizEkrani> createState() => _HosgeldinizEkraniState();
}

class _HosgeldinizEkraniState extends State<HosgeldinizEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawer(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GelirGiderGirisiEkrani(),
                ),
              );
            },
            child: Text("Gelir Gider Giriş"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GelirGiderHesaplamaEkrani(),
                ),
              );
            },
            child: Text("Gelir Gider Hesaplama"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AyarlarEkrani(),
                ),
              );
            },
            child: Text("Ayarlar"),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("HOŞ GELDİNİZ!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              // Hero animasyonunu tetiklemek için resme tıklanır
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilResmiBuyutulmusEkran(
                    profilResmi: widget.profilResmi,
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'profile-image', // Bu tag'i hem kaynağa hem hedefe kullanacağız
              child: CircleAvatar(
                radius: 50,
                backgroundImage: widget.profilResmi != null
                    ? MemoryImage(widget.profilResmi!)
                    : AssetImage('assets/placeholder.png') as ImageProvider,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Merhaba, ${widget.kullaniciAdi.toUpperCase()}!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Firma Adı: "),
              Text(widget.firmaAdi.isNotEmpty ? widget.firmaAdi : "Firma adı belirtilmedi.", style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ProfilResmiBuyutulmusEkran extends StatelessWidget {
  final Uint8List? profilResmi;

  ProfilResmiBuyutulmusEkran({this.profilResmi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: 'profile-image', // Aynı tag ile hedef ekranı eşleştiriyoruz
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Resme tıklandığında geri dönüyoruz
            },
            child: CircleAvatar(
              radius: 150,
              backgroundImage: profilResmi != null
                  ? MemoryImage(profilResmi!)
                  : AssetImage('assets/placeholder.png') as ImageProvider,
            ),
          ),
        ),
      ),
    );
  }
}*/