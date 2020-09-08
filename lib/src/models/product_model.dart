import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/models/category_model.dart';

class ProductModel {
  String _id;
  String _name;
  List<String> _images = [];
  String _details;
  String _deliveryInfo;
  String _deliveryTime;
  int _price;
  int _discountPrice;
  ProductCategoryModel _category;
  BrandModel _brand;
  int _stock;

  ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _name = parsedJson['name'];

    List<String> tempImages = [];
    for(int i = 0; i < parsedJson['images'].length; i++) {
      tempImages.add(parsedJson['images'][i]);
    }
    _images = tempImages;

    _details = parsedJson['details'];
    _deliveryInfo = parsedJson['delivery_info'];
    _deliveryTime = parsedJson['delivery_time'];
    _price = int.parse(parsedJson['price']);
    _discountPrice = parsedJson['discount_price'] == "" ? null : int.parse(parsedJson['discount_price']);
    _category = ProductCategoryModel.fromJson(parsedJson['category']);
    _brand = BrandModel.fromJson(parsedJson['brand']);
    _stock = int.parse(parsedJson['stock']);
  }

  String get id => _id;

  String get name => _name;

  List<String> get images => _images;

  String get details => _details;

  String get deliveryInfo => _deliveryInfo;

  String get deliveryTime => _deliveryTime;

  int get price => _price;

  int get discountPrice => _discountPrice;

  ProductCategoryModel get category => _category;

  BrandModel get brand => _brand;

  int get stock => _stock;
}

class ProductCategoryModel {
  String _id;
  String _name;
  List<FilterableValueModel> _filterableValues = [];

  ProductCategoryModel.fromJson(Map<String, dynamic> jsonObject) {
    _id = jsonObject["id"];
    _name = jsonObject["name"];

    List<FilterableValueModel> tempFilterableValues = [];
    for(int i = 0; i < jsonObject["filterable_values"].length; i++) {
      tempFilterableValues.add(new FilterableValueModel.fromJson(jsonObject["filterable_values"][i]));
    }
    _filterableValues = tempFilterableValues;
  }

  String get id => _id;

  String get name => _name;

  List<FilterableValueModel> get filterableValues => _filterableValues;


}

class FilterableValueModel {
  String _filterableId;
  String _filterableName;
  String _filterableValue;

  FilterableValueModel(String filterableId, String filterableName, String filterableValue) {
    _filterableId = filterableId;
    _filterableName = filterableName;
    _filterableValue = filterableValue;
  }

  FilterableValueModel.fromJson(Map<String, dynamic> jsonObject) {
    _filterableId = jsonObject["filterable_id"];
    _filterableName = jsonObject["filterable_name"];
    _filterableValue = jsonObject["filterable_value"];
  }

  String get filterableId => _filterableId;

  String get filterableName => _filterableName;

  String get filterableValue => _filterableValue;
}