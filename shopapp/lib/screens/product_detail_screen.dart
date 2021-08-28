import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final _loadedproducts =
        Provider.of<ProductsProvider>(context, listen: false)
            .filterbyid(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _loadedproducts.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _loadedproducts.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${_loadedproducts.price}",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
              "${_loadedproducts.description}",
              softWrap: true,
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    );
  }
}
