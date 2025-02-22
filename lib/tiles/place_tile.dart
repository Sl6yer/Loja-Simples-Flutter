import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>?; // Converte para Map

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100.0,
            child: data != null
                ? Image.network(
                    data['image'] ?? '', // Se for null, usa uma string vazia
                    fit: BoxFit.cover,
                  )
                : Center(
                    child:
                        CircularProgressIndicator()), // Mostra um indicador se os dados não carregaram
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data!['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  data['address'],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (data.containsKey('latitude') &&
                      data.containsKey('longitude')) {
                    final latitude = data['latitude'];
                    final longitude = data['longitude'];

                    // Verifique se latitude e longitude não são nulos e são do tipo correto (número)
                    if (latitude != null &&
                        longitude != null &&
                        latitude is num &&
                        longitude is num) {
                      final Uri url = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                      launchUrl(url);
                    } else {
                      print(
                          'Erro: Latitude ou Longitude estão incorretos ou são nulos');
                    }
                  } else {
                    print(
                        'Erro: Latitude ou Longitude não estão no banco de dados');
                  }
                },
                child: Text(
                  'Ver no Mapa',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  ligarPara(data['phone']);
                },
                child: Text(
                  'Ligar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void ligarPara(String telefone) async {
    final Uri uri = Uri(scheme: 'tel', path: telefone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Não foi possível iniciar a chamada para $telefone';
    }
  }
}
