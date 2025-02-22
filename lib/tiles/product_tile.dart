import 'package:flutter/material.dart';
import 'package:loja/datas/product_data.dart';
import 'package:loja/screens/products_screen.dart';
import 'package:loja/screens/about_product_screen.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.type, required this.data});

  final String type;
  final ProductData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AboutProductScreen(
                  product: data,
                )));
      },
      child: Card(
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (data.images != null && data.images!.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 0.85,
                      child: Image.network(
                        data.images?[0],
                        errorBuilder: (context, error, strackTrace) {
                          print(
                              'Erro ao carregar a imagem: ${data.images![0]}');
                          return Icon(
                            Icons.broken_image,
                            size: 50,
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.title!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "R\$ ${data.price!.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      data.images![0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "R\$ ${data.price!.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
