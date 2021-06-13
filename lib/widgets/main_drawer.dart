import 'package:Shop_App/screens/orders_screen.dart';
import 'package:Shop_App/screens/products_overview_screen.dart';
import 'package:Shop_App/screens/user_product_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello Friend !"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Products"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName);
          },
        ),
      ]),
    );
  }
}
