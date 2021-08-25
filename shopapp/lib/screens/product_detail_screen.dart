import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:shopapp/providers/products_provider.dart';
class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final _loadedproducts=Provider.of<ProductsProvider>(context, listen: false).filterbyid(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(_loadedproducts.title),
      ),
    );
  }
}