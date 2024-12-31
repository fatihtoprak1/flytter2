import 'package:flutter/material.dart';
import 'package:odev5/diger_kullanicilar.dart';
import 'package:odev5/veritabani.dart';


class BilgilerimSayfasi extends StatefulWidget {
  @override
  _BilgilerimSayfasiState createState() => _BilgilerimSayfasiState();
}

class _BilgilerimSayfasiState extends State<BilgilerimSayfasi> {
  final TextEditingController isim = TextEditingController();
  final TextEditingController soyisim = TextEditingController();
  String cinsiyet = "Erkek";
  String dogumTarihi="";
  List<String> hobiler = [];
  final List<String> hobiListesi = ["Kitap Okuma", "Spor", "Müzik", "Yazılım", "Seyahat"];
  final ScrollController _scrollController = ScrollController();

  void bilgiKaydet() async {
    String seciliHobiler = hobiler.join(", ");
    await KullaniciVeritabani().kullaniciEkle({
      'isim': isim.text,
      'soyisim': soyisim.text,
      'cinsiyet': cinsiyet,
      'hobiler': seciliHobiler,
      'dogum_tarihi': dogumTarihi,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bilgileriniz kaydedildi.")),
    );
  }

  void hobiSecimi(bool? secildi, String hobi) {
    setState(() {
      if (secildi == true) {
        hobiler.add(hobi);
      } else {
        hobiler.remove(hobi);
      }
    });
  }
  void sayfaninYukarisi1() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  void tarihSec(BuildContext context) async {
    DateTime? secilenTarih = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      
    );
    if (secilenTarih != null) {
      setState(() {
        dogumTarihi = "${secilenTarih.toLocal()}".split(' ')[0];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bilgilerim")),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: isim,
                decoration: InputDecoration(labelText: "İsim"),
              ),
              TextField(
                controller: soyisim,
                decoration: InputDecoration(labelText: "Soyisim"),
              ),
              SizedBox(height: 15),
              Text("Cinsiyet"),
              Row(
                children: [
                  Radio(
                    value: "Erkek",
                    groupValue: cinsiyet,
                    onChanged: (value) => setState(() => cinsiyet = value.toString()),
                  ),
                  Text("Erkek"),
                  Radio(
                    value: "Kadın",
                    groupValue: cinsiyet,
                    onChanged: (value) => setState(() => cinsiyet = value.toString()),
                  ),
                  Text("Kadın"),
                ],
              ),
              SizedBox(height: 15),
              Text("Hobiler"),
              Column(
                children: hobiListesi.map((hobi) {
                  return CheckboxListTile(
                    title: Text(hobi),
                    value: hobiler.contains(hobi),
                    onChanged: (secildi) => hobiSecimi(secildi, hobi),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              Text("Doğum Tarihi: $dogumTarihi"),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => tarihSec(context),
                child: Text("Tarih Seç"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: bilgiKaydet,
                child: Text("Kaydet"),
              ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DigerKullanicilarSayfasi()),
                ),
                child: Icon(Icons.people),
                tooltip: "Diğer Kullanıcılar",
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sayfaninYukarisi1,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
