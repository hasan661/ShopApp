import 'package:flutter/material.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato'
      ),
     

      routes: {
        "/": (ctx) => ProductOverviewScreen(),
        ProductDetailScreen.routeName:(ctx)=> ProductDetailScreen()
      },
    );
  }
}


