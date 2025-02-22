import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/screens/products_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    var data = snapshot.data() as Map<String, dynamic>;
    var iconUrl = data['icon'];
    var title = data['title'];

    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(iconUrl),
      ),
      title: Text(title),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsScreen(
              snapshot: snapshot,
            ),
          ),
        );
      },
    );
  }
}
