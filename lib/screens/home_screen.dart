import 'package:flutter/material.dart';
import 'package:loja/main.dart';
import 'package:loja/tabs/home_tab.dart';
import 'package:loja/tabs/orders_tab.dart';
import 'package:loja/tabs/places_tab.dart';
import 'package:loja/widgets/cart_button.dart';
import 'package:loja/widgets/custom_drawer.dart';
import 'package:loja/tabs/products_tab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
  });

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(0, 255, 255, 0.5),
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Meus Pedidos'),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(pageController: _pageController),
        )
      ],
    );
  }
}
