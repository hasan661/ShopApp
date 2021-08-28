import 'package:flutter/material.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/orderitem.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  // const OrdersScreen({ Key? key }) : super(key: key);
  static const routeName="/orders";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) => OrderItem(orderData.orders[index]),
      ),
    );
  }
}
