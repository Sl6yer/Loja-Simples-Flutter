import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/datas/cart_product.dart';
import 'package:loja/datas/product_data.dart';
import 'package:loja/models/cart_model.dart';

class CartTile extends StatelessWidget {
  const CartTile({super.key, required this.cartProduct});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productData?.images![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData!.title!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'Geração: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: cartProduct.quantity! > 1
                              ? () {
                                  CartModel.of(context).decProduct(cartProduct);
                                }
                              : null,
                          icon: Icon(
                            Icons.remove,
                            color: Theme.of(context).primaryColor,
                          )),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                          onPressed: () {
                            CartModel.of(context).incProduct(cartProduct);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          )),
                      TextButton(
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                        child: Text(
                          'Remover',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[500],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(cartProduct.category)
                    .collection('items')
                    .doc(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data!);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
