import 'package:my_store/src/models/orders_result_model.dart';

enum EventType{add}

class OrderListEvent {
  OrdersResultModel ordersResultItem;
  EventType eventType;

  OrderListEvent();

  OrderListEvent.add(OrdersResultModel ordersResultItem) {
    this.eventType = EventType.add;
    this.ordersResultItem = ordersResultItem;
  }
}