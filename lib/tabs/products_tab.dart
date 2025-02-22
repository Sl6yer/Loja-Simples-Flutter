import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data?.docs.map<Widget>((doc) {
                        return CategoryTile(
                          snapshot: doc,
                        );
                      }).toList() ??
                      [],
                  color: Colors.grey[700])
              .toList();

          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
