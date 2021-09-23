import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cartitem.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cartData.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartData: cartData)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.itemcount,
            itemBuilder: (ctx, index) => CartItem(
                quantity: cartData.items.values.toList()[index].quantity,
                price: cartData.items.values.toList()[index].price,
                id: cartData.items.values.toList()[index].id,
                title: cartData.items.values.toList()[index].title,
                prodid: cartData.items.keys.toList()[index],),
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartData.totalAmount <=0 || _isLoading)? null : () async {
        setState(() {
          _isLoading=true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(widget.cartData.items.values.toList(), widget.cartData.totalAmount);
                setState(() {
          _isLoading=false;
        });

        widget.cartData.clearcart();
      },
      child: _isLoading?CircularProgressIndicator() :Text(
        "PLACE ORDER",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
