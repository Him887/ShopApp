import 'package:Shop_App/screens/auth_screen.dart';
import 'package:Shop_App/screens/edit_product_screen.dart';
import 'package:Shop_App/screens/orders_screen.dart';
import 'package:Shop_App/screens/user_product_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Products(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(), 
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(), 
          ),
        ],
        child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.orange,
              fontFamily: 'Lato'),
          home: AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(), 
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        )
    );
  }
}
