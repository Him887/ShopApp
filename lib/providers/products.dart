import 'package:Shop_App/models/http_exception.dart';

import './product.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Pink Shirt',
    //   description: 'A red shirt - it is pretty pink!',
    //   price: 23,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Pant',
    //   description: 'A nice pair of pant.',
    //   price: 80,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isfavourite == true).toList();
  }

  Product findById(String id) {
    return [..._items].firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = "https://shop-app-a7802.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if(extractedData != null ) {
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isfavourite: prodData['isFavourite'],
            price: prodData['price']));
          });
      }
      _items = loadedProducts.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = "https://shop-app-a7802.firebaseio.com/products.json";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavourite': product.isfavourite,
          'price': product.price
        }),
      );
      var newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, newProduct);
      print(json.decode(response.body)['name']);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateproduct(String id, Product product) async {
    var productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = "https://shop-app-a7802.firebaseio.com/products/$id.json";
      await http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl
        }),
      );
      _items[productIndex] = product;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = "https://shop-app-a7802.firebaseio.com/products/$id.json";
    var productIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could Not Delete Product");
    }
    existingProduct = null;
  }
}
