import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import 'package:shopapp/screens/editproductscreen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageURL;
  final String id;

  UserProductItem(this.title, this.imageURL, this.id);



  @override
  Widget build(BuildContext context) {
    final scaffold=ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
        
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
          }, icon: Icon(Icons.edit), color:  Theme.of(context).primaryColor,),
          IconButton(onPressed: () async {
            try{
            await Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
            }
            catch(error){
              scaffold.showSnackBar(SnackBar(content: Text("Failed To Delete",textAlign: TextAlign.center,)));
            }
          }, icon: Icon(Icons.delete), color: Theme.of(context).errorColor,)
        ],),
      ),
    );
  }
}
