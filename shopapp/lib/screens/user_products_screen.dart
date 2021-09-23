import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/editproductscreen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/userproductitem.dart';

import '../providers/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = "/userproductscreen";

  Future<void> _refreshProducts(BuildContext context) async{
    Provider.of<ProductsProvider>(context, listen: false).fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(
      context,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Products"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: ()=> _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_, index) => Column(
                children: [
                  UserProductItem(
                    productData.items[index].title,
                    productData.items[index].imageUrl,
                    productData.items[index].id
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ));
  }
}
