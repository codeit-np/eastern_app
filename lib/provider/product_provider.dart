import 'package:final_food_app/model/product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  int _totalItems = 0;
  double _totalAmount = 0;
  List<ProductModel> _products = [];

  // Make it true if product found in cart
  bool flag = false;
  int index = 0;

// Add Product to cart
  void addProduct(String id, String name, int qty, int sp, String img) {
    // Check if products list contain any products inside it
    // if product list doesn't have any product in its list add first product to it whose index number will be 0

    // if products list contain any product inside it we need to check every product if this list contain previous product id
    // We are using Prime number logic to check it if product list contain product insert by user
    if (_products.length == 0) {
      _totalItems++;
      _products
          .add(ProductModel(id: id, name: name, qty: qty, sp: sp, image: img));
      _products[0].amount = qty * sp;
      _totalAmount = _totalAmount + _products[0].amount;
    } else {
      // Price Number Logic
      // Check if product contains product id
      //  if product id found break the loop
      for (var product in _products) {
        if (product.id == id) {
          flag = true;
          break;
        }
        index++;
      }

      //If Product Found in _products List
      if (flag == true) {
        //Increase previous qty + current qty
        _products[index].qty = products[index].qty + qty;

        //Current amount = total qty * sp
        _products[index].amount = _products[index].qty * sp;

        //Total Cart Amount = provious total + current amount of product
        _totalAmount = _totalAmount + (qty * sp);

        index = 0;
        flag = false;
      } else {
        // If First product is already in cart
        _totalItems++;
        _products.add(
            ProductModel(id: id, name: name, qty: qty, sp: sp, image: img));

        _products[index].amount = qty * sp;
        _totalAmount = _totalAmount + _products[index].amount;

        index = 0;
        flag = false;
      }
    }
    notifyListeners();
  }

  // Remoce Product From Cart
  void removeProduct(String id) {
    for (var product in _products) {
      if (product.id == id) {
        flag = true;
        break;
      }
      index++;
    }

    // If Product found inf _products List
    // Remove that product from _products List and also need to subtract Product amount from total cart amount
    if (flag == true) {
      _totalItems--;
      _totalAmount = _totalAmount - products[index].amount;
      products.remove(products[index]);
      index = 0;
      flag = false;
    }

    notifyListeners();
  }

  void reset() {
    _products.clear();
    _totalAmount = 0;
    _totalItems = 0;
  }

  int get totalItems {
    return _totalItems;
  }

  double get totalAmount {
    return _totalAmount;
  }

  List<ProductModel> get products {
    return _products;
  }
}
