import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        color: Theme.of(context).errorColor,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            )),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Are You Sure??"),
                content: Text("Do you want to remove this Item from the Cart?"),
                elevation: 4,
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("No")),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    }, 
                    child: Text("Yes")),
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(child: Text('\$ $price'))),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${(price * quantity)}'),
              trailing: Text('$quantity x'),
            ),
          )),
    );
  }
}
