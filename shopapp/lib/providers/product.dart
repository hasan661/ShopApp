import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
    required this.price,
    required this.title,
  });
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
  Future<void> toggleFavorite(String? token, String? userid) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    
    

    notifyListeners();
    final Uri url = Uri.parse(
        "https://shopapp-6589d-default-rtdb.firebaseio.com/userFavorites/$userid/$id.json?auth=$token");

    
    try{
    final response=await http.put(
      url,
      body: json.encode(
        
          isFavorite,
        
      ),
    );
    print(response.statusCode);
    if(response.statusCode>=400)
    {
      _setFavValue(oldStatus);
    }
    }
    catch(error)
    {
      
      _setFavValue(oldStatus);
      
    }
  }
}
