import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String? category;
  String? id;
  String? title;
  String? description;

  double? price;

  List? images;
  List? size;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    id = snapshot.id;
    title = data['title'];
    description = data['description'];
    price = data['price'] + 0.0;
    images = data['images'];
    size = data['size'];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}
