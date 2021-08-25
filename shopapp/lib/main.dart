import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx)=>ProductsProvider(), //Builder is used in version 3 in above 3 we use create
      child: MaterialApp(
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
      ),
    );
  }
}


