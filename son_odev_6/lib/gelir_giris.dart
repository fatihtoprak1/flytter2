import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:son_odev_6/veritabani.dart';

class GelirGiderGirisiEkrani extends StatefulWidget {
  @override
  _GelirGiderGirisiEkraniState createState() => _GelirGiderGirisiEkraniState();
}

class _GelirGiderGirisiEkraniState extends State<GelirGiderGirisiEkrani> {
  final _formKey = GlobalKey<FormState>();
  DateTime? secilenTarih;
  String? gelirGiderTuru;
  double? miktar;
  String? aciklama;

  void tarihSec(BuildContext context) async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (secilen != null) {
      setState(() {
        secilenTarih = secilen;
      });
    }
  }

void kaydet() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    if (secilenTarih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir tarih seçiniz!')),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(secilenTarih!);

    if (gelirGiderTuru == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir gelir/gider türü seçiniz!')),
      );
      return;
    }

    if (miktar == null || miktar! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Miktar geçerli olmalıdır!')),
      );
      return;
    }

    try {
      final veritabani = await VeriTabani().veritabani;

      await veritabani.insert('gelir_gider', {
        'tarih': formattedDate,
        'tur': gelirGiderTuru,
        'miktar': miktar,
        'aciklama': aciklama,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarıyla eklendi!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        secilenTarih = null;
        gelirGiderTuru = null;
        miktar = null;
        aciklama = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri eklenirken bir hata oluştu: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir-Gider Girişi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text(secilenTarih != null
                    ? DateFormat('dd/MM/yyyy').format(secilenTarih!)
                    : 'Tarih seçiniz'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => tarihSec(context),
              ),
              DropdownButtonFormField<String>(
                items: ['Gelir', 'Gider']
                    .map((tur) => DropdownMenuItem(value: tur, child: Text(tur)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gelirGiderTuru = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Tür Seçiniz'),
                validator: (value) =>
                    value == null ? 'Lütfen bir tür seçiniz!' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Miktar (TL)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Miktar zorunludur!' : null,
                onSaved: (value) => miktar = double.tryParse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Açıklama'),
                validator: (value) =>
                    value!.isEmpty ? 'Açıklama zorunludur!' : null,
                onSaved: (value) => aciklama = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: kaydet,
                child: Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}