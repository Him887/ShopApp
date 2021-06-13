import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavOnly;

  ProductsGrid(this.showFavOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavOnly ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
