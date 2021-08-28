import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.price,
    required this.title,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  void addItem(
    String productid,
    double price,
    String title,
  ) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (existingitem) => CartItem(
              id: existingitem.id,
              price: existingitem.price,
              title: existingitem.title,
              quantity: existingitem.quantity + 1));
      
    } else {
      _items.putIfAbsent(
        productid,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            title: title,
            quantity: 1),
      );
      
    }
    notifyListeners();
  }
}
