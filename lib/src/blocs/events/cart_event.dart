import 'package:my_store/src/models/cart_item_model.dart';

enum EventType{add, remove, updateCount, clear}

class CartEvent {
  CartItemModel cartItem;
  int cartIndex;
  int updateCount;
  EventType eventType;
  
  CartEvent();
  
  CartEvent.add(CartItemModel cartItem) {
    this.eventType = EventType.add;
    this.cartItem = cartItem;
  }

  CartEvent.updateCount(int index, int count){
    this.eventType = EventType.updateCount;
    this.cartIndex = index;
    this.updateCount = count;
  }
  
  CartEvent.remove(int index) {
    this.eventType = EventType.remove;
    this.cartIndex = index;
  }

  CartEvent.clear() {
    this.eventType = EventType.clear;
  }
}