import 'package:flutter/material.dart';
import 'package:odev5/bilgilerim.dart';
import 'package:odev5/veritabani.dart';

class GirisYapSayfasi extends StatefulWidget {
  @override
  _GirisYapSayfasiState createState() => _GirisYapSayfasiState();
}

class _GirisYapSayfasiState extends State<GirisYapSayfasi> {
  final TextEditingController kullaniciAdi = TextEditingController();
  final TextEditingController sifre = TextEditingController();

  void girisYap() async {
    final kullanici = await KullaniciVeritabani().kullaniciKontrol(
      kullaniciAdi.text,
      sifre.text,
    );

    if (kullanici != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BilgilerimSayfasi()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hatalı kullanıcı adı veya şifre!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap")),
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
              onPressed: girisYap,
              child: Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
