import 'package:Shop_App/providers/product.dart';
import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/user-products/edit";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: "", description: "", imageUrl: "", price: 0);
  var _isInit = true;
  var _initValues = {
    'title': "",
    'description': "",
    'price': "",
    // 'imageUrl': ""
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'ImageUrl': _editedProduct.imageUrl
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateproduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Something went Wrong!!"),
                content: Text("Plz try Again"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Dismiss"))
                ],
              );
            }
          );
      } finally {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        initialValue: _initValues['title'],
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isfavourite: _editedProduct.isfavourite,
                              title: value,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter some value.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        initialValue: _initValues['price'],
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isfavourite: _editedProduct.isfavourite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value));
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter some price.";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid Number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a valid Price";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: "Description"),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          initialValue: _initValues['description'],
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                isfavourite: _editedProduct.isfavourite,
                                description: value,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter some Description";
                            }
                            if (value.length < 10) {
                              return "Description should have atleast 10 characters";
                            }
                            return null;
                          }),
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
                                border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            )),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter Image URL")
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URl"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      isfavourite: _editedProduct.isfavourite,
                                      description: _editedProduct.description,
                                      imageUrl: value,
                                      price: _editedProduct.price);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter URL.";
                                  }
                                  return null;
                                }),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
