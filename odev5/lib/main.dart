import 'package:flutter/material.dart';
import 'package:odev5/kayit_ol.dart';

void main() {
  runApp(KullaniciUygulamasi());
}

class KullaniciUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kullanıcı Uygulaması',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue
        ),
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white
        ),
      home: KayitOlSayfasi(),
      debugShowCheckedModeBanner: false,
    );
  }
}
