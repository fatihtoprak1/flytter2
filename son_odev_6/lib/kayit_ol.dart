import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:son_odev_6/giris_yap.dart';
import 'package:son_odev_6/veritabani.dart';

class KaydolEkrani extends StatefulWidget {
  @override
  _KaydolEkraniState createState() => _KaydolEkraniState();
}

class _KaydolEkraniState extends State<KaydolEkrani> {
  final _formKey = GlobalKey<FormState>();
  String? kullaniciAdi;
  String? parola;
  String? parolaTekrar;
  String? firmaAdi;
  File? profilResmi;

  void resimSec() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profilResmi = File(pickedFile.path);
      });
    }
  }
void kaydet() async {
  if (_formKey.currentState!.validate()) {
    if (parola != parolaTekrar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parolalar eşleşmiyor!')),
      );
      return;
    }

    _formKey.currentState!.save();
    final veritabani = await VeriTabani().veritabani;

    try {
      await veritabani.insert('kullanicilar', {
        'kullanici_adi': kullaniciAdi,
        'parola': parola,
        'firma_adi': firmaAdi,
        'profil_resmi': profilResmi != null ? profilResmi!.path : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarılı!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GirisEkrani()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }
}

 /*void kaydet() async {
  if (_formKey.currentState!.validate()) {
    if (parola != parolaTekrar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parolalar eşleşmiyor!')),
      );
    } else {
      _formKey.currentState!.save();

      final veritabani = await VeriTabani().veritabani;

      // Veritabanına kullanıcıyı ekle
      await veritabani.insert('kullanicilar', {
        'kullanici_adi': kullaniciAdi,
        'parola': parola,
        'firma_adi': firmaAdi,
        'profil_resmi': profilResmi != null
            ? profilResmi!.readAsBytesSync()
            : null,
      });

      // Kayıt işlemi başarılıysa log yaz
      print("Kullanıcı kaydedildi: $kullaniciAdi");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarılı!')),
      );

      // Giriş ekranına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GirisEkrani(), // Giriş ekranına yönlendir
        ),
      );
    }
  }
}*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kaydol')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Parola Tekrar'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Parola tekrar zorunludur!' : null,
                  onSaved: (value) => parolaTekrar = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Firma Adı'),
                  onSaved: (value) => firmaAdi = value,
                ),
                SizedBox(height: 20),
                profilResmi != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(profilResmi!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                TextButton.icon(
                  onPressed: resimSec,
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Profil Resmi Seç'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (parola != parolaTekrar) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Parolalar eşleşmiyor!')),
                      );
                      return;
                    }
                    // Veritabanı işlemi
                    final veritabani = await VeriTabani().veritabani;

                    await veritabani.insert('kullanicilar', {
                      'kullanici_adi': kullaniciAdi,
                      'parola': parola,
                      'firma_adi': firmaAdi,
                      'profil_resmi': profilResmi != null
                          ? profilResmi!.readAsBytesSync()
                          : null,
                    });
              
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kayıt başarılı!')),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GirisEkrani()),
                    );
                  }
                },
                child: Text('Kaydol'),
              ),
              TextButton(
                  onPressed: () {             
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => GirisEkrani(),
                      ),
                    );
                  },
                  child: Text('Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}