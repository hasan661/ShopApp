import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = "/editproduct";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageurlcontroller = TextEditingController();
  final _imageURLfocusnode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  var _editiedProducts = Product(
    id: "",
    description: "",
    imageUrl: "",
    price: 0,
    title: "",
  );
  var initvalue = {"title": '', 'description': '', 'price': '', 'imageURL': ''};
  var _isIit = true;

  @override
  void initState() {
    _imageURLfocusnode.addListener(_updateImageURL);
    super.initState();
  }

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isIit) {
      final productid = ModalRoute.of(context)!.settings.arguments;
      if (productid != null) {
        _editiedProducts = Provider.of<ProductsProvider>(context, listen: false)
            .filterbyid(productid);
        initvalue = {
          "title": _editiedProducts.title,
          'description': _editiedProducts.description,
          'price': _editiedProducts.price.toString(),
          'imageURL': ''
        };
        _imageurlcontroller.text = _editiedProducts.imageUrl;
      }
    }
    _isIit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlcontroller.dispose();
    _imageURLfocusnode.removeListener(_updateImageURL);
    _imageURLfocusnode.dispose();

    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageURLfocusnode.hasFocus) {
      if ((!_imageurlcontroller.text.startsWith("http") &&
              !_imageurlcontroller.text.startsWith("https")) ||
          (!_imageurlcontroller.text.endsWith(".png") &&
              !_imageurlcontroller.text.endsWith(".jpg") &&
              !_imageurlcontroller.text.endsWith("jpeg"))) {
        return;
      }

      setState(
        () {},
      );
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formkey.currentState!.validate();
    // print("1");
    if (!isValid) {
      return;
    }
    // print("2
    setState(() {
      // print("3");
      _isLoading = true;
    });
    // print("4");
    _formkey.currentState!.save();
    if (_editiedProducts.id != "") {
      // print("5");
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editiedProducts.id, _editiedProducts);
      
    } else {
      // print("6");
      try{
      await Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editiedProducts);
      }
      catch(error){
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text("Something Went Wrong"),
            actions: [
              TextButton(
                  onPressed: () {
                    
                    Navigator.of(ctx).pop();
                    
                    
                    
                  },
                  child: Text("Okay"))
            ],
          ),
          
        );

      }
      // finally{
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
          
          
        
      
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initvalue['title'],
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editiedProducts = Product(
                            id: _editiedProducts.id,
                            description: _editiedProducts.description,
                            imageUrl: _editiedProducts.imageUrl,
                            price: _editiedProducts.price,
                            title: value.toString(),
                            isFavorite: _editiedProducts.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a title";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: initvalue['price'],
                      decoration: InputDecoration(
                        labelText: "Price",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _editiedProducts = Product(
                          id: _editiedProducts.id,
                          description: _editiedProducts.description,
                          imageUrl: _editiedProducts.imageUrl,
                          price: double.parse(value.toString()),
                          title: _editiedProducts.title,
                          isFavorite: _editiedProducts.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a Price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please Enter A number greater then 0";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initvalue['description'],
                      decoration: InputDecoration(
                        labelText: "Desciption",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editiedProducts = Product(
                          id: _editiedProducts.id,
                          description: value.toString(),
                          imageUrl: _editiedProducts.imageUrl,
                          price: _editiedProducts.price,
                          title: _editiedProducts.title,
                          isFavorite: _editiedProducts.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a Description";
                        }
                        if (value.length < 10) {
                          return "Atleast add 10 characters";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageurlcontroller.text.isEmpty
                              ? Text("Enter A Url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageurlcontroller.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: initvalue['imageURL'],
                            decoration: InputDecoration(
                              labelText: "Image URL",
                              // focusColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageurlcontroller,
                            focusNode: _imageURLfocusnode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editiedProducts = Product(
                                id: _editiedProducts.id,
                                description: _editiedProducts.description,
                                imageUrl: value.toString(),
                                price: _editiedProducts.price,
                                title: _editiedProducts.title,
                                isFavorite: _editiedProducts.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Provide an imageURL";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter a valid URL";
                              }
                              if (!value.endsWith(".png") &&
                                  !value.endsWith(".jpg") &&
                                  !value.endsWith("jpeg")) {
                                return "Please enter a valid URL";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
