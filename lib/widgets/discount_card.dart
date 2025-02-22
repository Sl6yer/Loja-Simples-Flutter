import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection('cupoms')
                    .doc(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.exists && docSnap.data() != null) {
                    // Verifica se o cupom existe
                    final data = docSnap.data() as Map<String, dynamic>;
                    CartModel.of(context).setCupom(text, data['percent'] ?? 0);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Desconto de ${data['percent']}% aplicado!'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    CartModel.of(context).setCupom("", 0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cupom não existente!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }).catchError((error) {
                  print("Erro ao buscar cupom: $error");
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
