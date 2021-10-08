import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

import 'package:shopapp/models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? authToken;
  final String? userid;
  ProductsProvider(this.authToken, this._items, this.userid);
  // "https://shopapp-6589d-default-rtdb.firebaseio.com/userFavorites/$userid/$id.json?auth=$token"
  Future<void> fetchproducts([bool filterbyUser = false]) async {
    // print(userid.runtimeType);
    final filterstring=filterbyUser? 'orderBy="creatorId"&equalTo="$userid"' : '';
    
    Uri url = Uri.parse(
        'https://shopapp-6589d-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterstring');
                                                                                                  
      try{
      final response = await http.get(url,);
      // print(response.body);
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      // print(extracteddata);
      // print("0");

      Uri favoriteresponse=Uri.parse("https://shopapp-6589d-default-rtdb.firebaseio.com/userFavorites/$userid.json?auth=$authToken");
      // print("1");
      final responsefavorite=await http.get(favoriteresponse);
      // print("2");
      final favoritedData=json.decode(responsefavorite.body);
      // print("64");
      // print(favoritedData);
      
      final List<Product> loadedproducts = [];
      
      extracteddata.forEach((prodid, value) {
        // print(prodid);
        // print(favoritedData[prodid]);
        loadedproducts.add(Product(
            id: prodid,

            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            title: value['title'],
            isFavorite: favoritedData==null? false :  favoritedData[prodid] ?? false ));
      });
      _items = loadedproducts;
      notifyListeners();
      }
      catch(error){
        throw error;
      }
    
  
  }

  List<Product> get items {
    // if (_showFavoritesOnly)
    // {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get filteretditems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get favoriteitems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product filterbyid(var id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    Uri url = Uri.parse(
        "https://shopapp-6589d-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "creatorId":userid
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
        // isFavorite: :prid
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }

    // throw error;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    // print(prodIndex);
    if (prodIndex >= 0) {
      final Uri url = Uri.parse(
          "https://shopapp-6589d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
          // print("object1");
      final response=await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price
          }));
          // print("object");
          if(response.statusCode>=400)
          {
            throw HttpException("Your");
          }
      _items[prodIndex] = newProduct;
      print(response.statusCode);
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final Uri url = Uri.parse(
        "https://shopapp-6589d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingproduct = _items[existingProductIndex];
  _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingproduct);
      notifyListeners();
      throw HttpException("Could Not Delete Product");
    }
    existingproduct =
        Product(id: "", description: "", imageUrl: "", price: 0, title: "");
    
  }
}
