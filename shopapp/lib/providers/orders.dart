import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    Uri url = Uri.parse(
        "https://shopapp-6589d-default-rtdb.firebaseio.com/orders.json");
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }

  Future<void> fetchorders() async {
    Uri url = Uri.parse(
        "https://shopapp-6589d-default-rtdb.firebaseio.com/orders.json");
    final response = await http.get(url);
    final List<OrderItem> _loadedOrders = [];
    if(json.decode(response.body)==null){
      _orders=[];
      // print("I was here");
      return;

    }
    
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    

    
    extractedData.forEach((orderid, orderData) {
      _loadedOrders.add(OrderItem(
          id: orderid,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    title: e['title'],
                    quantity: e['quantity'],
                  ))
              .toList()));
    });
    _orders=_loadedOrders.reversed.toList();
    notifyListeners();
    print("Hasan");
  }
}
