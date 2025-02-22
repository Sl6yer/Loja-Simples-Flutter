import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/datas/cart_product.dart';
import 'package:flutter/material.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  String? cupomCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    int currentQuantity = cartProduct.quantity ?? 0;
    if (currentQuantity > 0) {
      cartProduct.quantity = currentQuantity - 1;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.firebaseUser!.uid)
          .collection('cart')
          .doc(cartProduct.cid)
          .update(cartProduct.toMap());

      notifyListeners();
    }
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = (cartProduct.quantity ?? 0) + 1;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void setCupom(String cupomCode, int discountPercentage) {
    this.cupomCode = cupomCode;
    this.discountPercentage = discountPercentage;

    updatePrices();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity! * (c.productData!.price ?? 0.0);
      }
    }
    return price; // Retorna o valor calculado
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.9;
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null; // Retorna null corretamente

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection('orders').add({
      "clientId": user.firebaseUser!.uid,
      "products": products.map((c) => c.toMap()).toList(), // Correção aqui
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('orders')
        .doc(refOrder.id)
        .set({
      "orderId": refOrder.id,
    });

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();

    for (DocumentSnapshot doc in query.docs) {
      await doc.reference.delete();
    }

    products.clear();
    cupomCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id; // Retorna corretamente o ID do pedido
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
