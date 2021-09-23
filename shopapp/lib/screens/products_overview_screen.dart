import 'package:flutter/material.dart';
import 'package:shopapp/providers/products_provider.dart';
import '/widgets/app_drawer.dart';
import '/screens/cart_screen.dart';

import '../widgets/product_grid.dart';

import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit=true;
  var _showOnlyFavorites = false;
  var _isLoading=false;
  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).fetchproducts(); // Does not work
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading=true;
      });
      
      Provider.of<ProductsProvider>(context).fetchproducts().then((value) {
        setState(() {
          _isLoading=false;
        });
      });
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productData=Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ShopApp"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedvalue) {
              setState(() {
                if (selectedvalue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else if (selectedvalue == FilterOptions.All) {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
                child: ch!,
                value: cartData.itemcount.toString(),
                color: Theme.of(context).accentColor),
                child:  IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                
          )
          
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),) :ProductsGrid(_showOnlyFavorites),
    );
  }
}
