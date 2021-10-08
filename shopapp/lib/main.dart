import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/editproductscreen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import 'package:shopapp/widgets/splash_screen.dart';

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
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider?>(
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userID),
          create: (ctx) => null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders?>(
          update: (ctx, auth, previousorders) => Orders(auth.token,
              previousorders == null ? [] : previousorders.orders, auth.userID),
          create: (ctx) => null,
        )
      ],
      //Builder is used in version 3 ,in above 3 we use create
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),

          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  
                ),
          // initialRoute: AuthScreen.routeName,
          routes: {
            // "/": (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
