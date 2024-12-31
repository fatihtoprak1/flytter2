import 'package:flutter/material.dart';
import 'package:son_odev_6/kayit_ol.dart';

void main() {
  runApp(GelirGiderApp());
}

class GelirGiderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gelir Gider Takip',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        //primarySwatch: Colors.blue,
      ),
    home: KaydolEkrani(),
    );
  }
}