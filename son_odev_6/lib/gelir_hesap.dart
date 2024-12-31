import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:son_odev_6/veritabani.dart';

class GelirGiderHesaplamaEkrani extends StatefulWidget {
  @override
  _GelirGiderHesaplamaEkraniState createState() =>
      _GelirGiderHesaplamaEkraniState();
}

class _GelirGiderHesaplamaEkraniState extends State<GelirGiderHesaplamaEkrani> {
  DateTime? baslangicTarihi;
  DateTime? bitisTarihi;
  List<Map<String, dynamic>> gelirGiderListesi = [];
  double toplamGelir = 0;
  double toplamGider = 0;

  void tarihSec(BuildContext context, bool isBaslangic) async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (secilen != null) {
      setState(() {
        if (isBaslangic) {
          baslangicTarihi = secilen;
        } else {
          bitisTarihi = secilen;
        }
      });
    }
  }

  void gelirGiderHesapla() async {
  if (baslangicTarihi == null || bitisTarihi == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lütfen tarih aralığını seçiniz!')),
    );
    return;
  }

  try {
    final veritabani = await VeriTabani().veritabani;

    final sonuc = await veritabani.rawQuery(
      '''
      SELECT * FROM gelir_gider 
      WHERE tarih BETWEEN ? AND ?
      ''',
      [
        DateFormat('yyyy-MM-dd').format(baslangicTarihi!),
        DateFormat('yyyy-MM-dd').format(bitisTarihi!),
      ],
    );

    double toplamGelirHesapla = 0;
double toplamGiderHesapla = 0;

for (var kayit in sonuc) {
  double miktar = kayit['miktar'] != null ? (kayit['miktar'] as num).toDouble() : 0.0;
  if (kayit['tur'] == 'Gelir') {
    toplamGelirHesapla += miktar;
  } else if (kayit['tur'] == 'Gider') {
    toplamGiderHesapla += miktar;
  }
}

setState(() {
  gelirGiderListesi = sonuc;
  toplamGelir = toplamGelirHesapla;
  toplamGider = toplamGiderHesapla;
});

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veri sorgularken bir hata oluştu: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir-Gider Hesaplama')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => tarihSec(context, true),
                    child: Text(baslangicTarihi != null
                        ? DateFormat('dd/MM/yyyy').format(baslangicTarihi!)
                        : 'Başlangıç Tarihi'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => tarihSec(context, false),
                    child: Text(bitisTarihi != null
                        ? DateFormat('dd/MM/yyyy').format(bitisTarihi!)
                        : 'Bitiş Tarihi'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: gelirGiderHesapla,
              child: Text('Hesapla'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: gelirGiderListesi.length,
                itemBuilder: (context, index) {
                  final kayit = gelirGiderListesi[index];
                  return ListTile(
                    title: Text(style: TextStyle(fontWeight: FontWeight.bold),"${kayit['tur']} - ${kayit['miktar']} TL"),
                    subtitle: Text('${kayit['aciklama']}'),
                    trailing: Text('${kayit['tarih']}'),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Toplam Gelir: ${toplamGelir.toStringAsFixed(2)} TL'),
                Text('Toplam Gider: ${toplamGider.toStringAsFixed(2)} TL'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}