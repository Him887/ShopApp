import 'package:Shop_App/providers/orders.dart';
import 'package:Shop_App/widgets/main_drawer.dart';
import 'package:Shop_App/widgets/order_item.dart' as ord;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
      _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders= Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      drawer: MyDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return ord.OrderItem(orders[i]);
              },
              itemCount: orders.length,
            ),
    );
  }
}
