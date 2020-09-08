import 'package:my_store/src/models/product_model.dart';

class CartItemModel {
  ProductModel _product;
  int _count;

  CartItemModel(product, count) {
    _product = product;
    _count = count;
  }

  ProductModel get product => _product;

  int get count => _count;

  set count(value) {
    _count = value;
  }
}