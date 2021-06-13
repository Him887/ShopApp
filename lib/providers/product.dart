import 'package:Shop_App/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isfavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isfavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    final url = "https://shop-app-a7802.firebaseio.com/products/$id.json";
    isfavourite = !isfavourite;
    notifyListeners();
    var response = await http.patch(url,
        body: json.encode({
          'isFavourite': isfavourite,
        }));
    if (response.statusCode >= 400) {
      isfavourite = !isfavourite;
      notifyListeners();
      throw HttpException("Something Went wrong");
    }
  }
}
