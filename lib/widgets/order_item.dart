import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/mm/yyyy   hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height:
                    min(widget.order.products.length * 20.0 + 100, 300),
                child: ListView(
                  children: widget.order.products.map((e) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Padding(
                            padding: EdgeInsets.all(5),
                            child: FittedBox(child: Text('\$ ${e.price}'))
                            ),
                          ),
                          title: Text(e.title),
                          subtitle: Text('Total: \$${(e.price * e.quantity)}'),
                          trailing: Text('${e.quantity} x'),
                        ),
                      )
                    );
                  }).toList(),
                ),
              )
          ],
        )
    );
  }
}
