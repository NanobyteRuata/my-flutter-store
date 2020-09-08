import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/product_model.dart';

class OrdersResultModel {
  String _id;
  DateTime _orderedDate;
  int _status;
  String _totalDeliveryTime;
  int _totalItemsCount;
  int _totalPrice;
  List<CartItemModel> _orderItems = [];

  OrdersResultModel(String id, DateTime orderedDate, int status, String totalDeliveryTime, int totalItemsCount, int totalPrice, List<CartItemModel> orderItems) {
    _id = id;
    _orderedDate = orderedDate;
    _status = status;
    _totalDeliveryTime = totalDeliveryTime;
    _totalItemsCount = totalItemsCount;
    _totalPrice = totalPrice;
    _orderItems = orderItems;
  }

  OrdersResultModel.fromJson(Map<String, dynamic> jsonResult) {
    _id = jsonResult["id"];
    _orderedDate = DateTime.parse(jsonResult["ordered_date"]);
    _status = int.parse(jsonResult["status"]);
    _totalDeliveryTime = jsonResult["total_delivery_time"];
    _totalItemsCount = int.parse(jsonResult["total_items_count"]);
    _totalPrice = int.parse(jsonResult["total_price"]);

    List<CartItemModel> tempOrderItems = [];
    jsonResult["order_items"].forEach((orderItem) {
      tempOrderItems.add(new CartItemModel(new ProductModel.fromJson(orderItem["product"]), int.parse(orderItem["count"])));
    });
    _orderItems = tempOrderItems;
  }

  String get id => _id;

  DateTime get orderedDate => _orderedDate;

  int get status => _status;

  String get totalDeliveryTime => _totalDeliveryTime;

  int get totalItemsCount => _totalItemsCount;

  int get totalPrice => _totalPrice;

  List<CartItemModel> get orderItems => _orderItems;

}