import 'package:Shop_App/providers/products.dart';
import 'package:Shop_App/widgets/main_drawer.dart';
import 'package:Shop_App/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, i) {
              return Column(
                children: [
                  UserProductItem(
                      products[i].id, products[i].title, products[i].imageUrl),
                  Divider(),
                ],
              );
            },
            itemCount: products.length,
          ),
        ),
      ),
    );
  }
}
