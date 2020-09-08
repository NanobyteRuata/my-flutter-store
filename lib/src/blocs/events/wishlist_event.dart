import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/product_model.dart';

enum EventType{add, remove}

class WishListEvent {
  ProductModel wishListItem;
  int updateCount;
  EventType eventType;

  WishListEvent();

  WishListEvent.add(ProductModel wishListItem) {
    this.eventType = EventType.add;
    this.wishListItem = wishListItem;
  }

  WishListEvent.remove(ProductModel wishListItem) {
    this.eventType = EventType.remove;
    this.wishListItem = wishListItem;
  }
}