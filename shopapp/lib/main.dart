import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/orders_screen.dart';

import '/providers/cart.dart';
import '/providers/orders.dart';
import '/screens/cart_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx)=>Orders(),)
      ],
      //Builder is used in version 3 ,in above 3 we use create
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        routes: {
          "/": (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName:(ctx)=>OrdersScreen(),
        },
      ),
    );
  }
}
