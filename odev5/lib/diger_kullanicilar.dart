import 'package:flutter/material.dart';
import 'package:odev5/veritabani.dart';

class DigerKullanicilarSayfasi extends StatefulWidget {
  @override
  _DigerKullanicilarSayfasiState createState() => _DigerKullanicilarSayfasiState();
}

class _DigerKullanicilarSayfasiState extends State<DigerKullanicilarSayfasi> {
  List<Map<String, dynamic>> kullanicilar = [];
  Map<String, bool> detayAcik = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    kullanicilariGetir();
  }

  void kullanicilariGetir() async {
    final liste = await KullaniciVeritabani().tumKullanicilariGetir();
    setState(() {
      kullanicilar = liste;
      for (var kullanici in kullanicilar) {
        detayAcik[kullanici['id'].toString()] = false;
      }
    });
  }

  void detayDegistir(String id) {
    setState(() {
      detayAcik[id] = !(detayAcik[id] ?? false);
    });
  }

  void sayfaninYukarisi() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void kullaniciSil(int id) async {
    await KullaniciVeritabani().kullaniciSil(id);
    kullanicilariGetir();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kullanıcı silindi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diğer Kullanıcılar")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: kullanicilar.length,
        itemBuilder: (context, index) {
          final kullanici = kullanicilar[index];
          final id = kullanici['id'].toString();
          return Card(
            child: Column(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  title: Text("${kullanici['isim']} ${kullanici['soyisim']}"),
                  onTap: () => detayDegistir(id),
                   trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      kullaniciSil(kullanici['id']);
                    },
                  ),
                ),
                if (detayAcik[id] == true)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cinsiyet: ${kullanici['cinsiyet']}"),
                        Text("Hobiler: ${kullanici['hobiler']}"),
                        Text("Doğum Tarihi: ${kullanici['dogum_tarihi']}"),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sayfaninYukarisi,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
