import 'package:flutter/material.dart';
import 'package:loja/models/cart_model.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/screens/login_screen.dart';
import 'package:loja/screens/order_screen.dart';
import 'package:loja/tiles/cart_tile.dart';
import 'package:loja/widgets/cart_price.dart';
import 'package:loja/widgets/discount_card.dart';
import 'package:loja/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITEMS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Faça um login para adicionar produtos!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          );
        } else if (model.products == null || model.products.length == 0) {
          return Center(
            child: Text(
              'Nenhum produto no carrinho!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView(
            children: [
              Column(
                children: [
                  ...model.products.map((product) {
                    return CartTile(
                      cartProduct: product,
                    );
                  }).toList(),
                ],
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(buy: () async {
                String? orderId = await model.finishOrder();
                if (orderId != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => OrderScreen(
                            orderId: orderId,
                          )));
                }
              }),
            ],
          );
        }
      }),
    );
  }
}
