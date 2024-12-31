import 'package:flutter/material.dart';
import 'package:odev5/giris_yap.dart';
import 'package:odev5/veritabani.dart';

class KayitOlSayfasi extends StatefulWidget {
  @override
  _KayitOlSayfasiState createState() => _KayitOlSayfasiState();
}

class _KayitOlSayfasiState extends State<KayitOlSayfasi> {
  final TextEditingController kullaniciAdi = TextEditingController();
  final TextEditingController sifre = TextEditingController();

  void kayitEkle() async {
      if (kullaniciAdi.text.trim().isNotEmpty && sifre.text.trim().isNotEmpty) {
        await KullaniciVeritabani().kullaniciEkle({
          'kullanici_adi': kullaniciAdi.text.trim(),
          'sifre': sifre.text.trim(),
        });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarılı")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => GirisYapSayfasi()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Alanlar boş bırakılamaz!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: kullaniciAdi,
              decoration: InputDecoration(labelText: "Kullanıcı Adı"),
            ),
            TextField(
              controller: sifre,
              obscureText: true,
              decoration: InputDecoration(labelText: "Şifre"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: kayitEkle,
              child: Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
