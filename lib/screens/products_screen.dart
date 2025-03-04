import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/datas/product_data.dart';
import 'package:loja/tiles/product_tile.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(data['title']),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                ),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('products')
                .doc(snapshot.id)
                .collection('items')
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        ProductData data = ProductData.fromDocument(
                            snapshot.data!.docs[index]);
                        data.category = this.snapshot.id;
                        return ProductTile(
                          type: 'grid',
                          data: data,
                        );
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ProductTile(
                          type:
                              'list', // Aqui alterei para "list" para diferenciar da grade
                          data: ProductData.fromDocument(
                              snapshot.data!.docs[index]),
                        );
                      },
                    ),
                  ],
                );
            },
          ),
        ));
  }
}
