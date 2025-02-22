import 'package:loja/datas/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String? cid;

  String? category;
  String? pid;

  int? quantity;
  String? size;

  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    cid = document.id;
    category = data['category'];
    pid = data['pid'];
    quantity = data['quantity'];
    size = data['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      'size': size,
      'product': productData != null ? productData!.toResumedMap() : {},
    };
  }
}
