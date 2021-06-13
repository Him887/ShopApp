import 'package:Shop_App/providers/orders.dart';

import '../widgets/cart_item.dart';

import '../providers/cart.dart' show Cart;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _hasItems = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final cart = Provider.of<Cart>(context);
    if (cart.itemCount > 0) {
      _hasItems = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$ ${cart.totalItemAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    if (_hasItems)
                      _isLoading
                          ? Row(
                            children: [
                              SizedBox(width: 50),
                              Center(child: CircularProgressIndicator(strokeWidth: 0.5,)),
                            ],
                          )
                          : FlatButton(
                              onPressed: () async {
                                setState(() {
                                    _isLoading = true;
                                });
                                try {
                                  await Provider.of<Orders>(context,
                                          listen: false)
                                      .addOrder(cart.items.values.toList(),
                                          cart.totalItemAmount);
                                  _hasItems = false;
                                  cart.clear();
                                } catch (error) {
                                  // SnackBar(content: Text("Something Wet Wrong"));
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Text(
                                "ORDER NOW",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 10,
                                ),
                              )),
                  ],
                )),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) {
              return CartItem(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  title: cart.items.values.toList()[i].title);
            },
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}
