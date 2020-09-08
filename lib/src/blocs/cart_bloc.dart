import 'package:bloc/bloc.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/blocs/events/cart_event.dart';
import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/product_model.dart';

class CartBloc extends Bloc<CartEvent, List<CartItemModel>>{

  CartBloc() : super([]);

  @override
  Stream<List<CartItemModel>> mapEventToState(CartEvent event) async* {
    switch(event.eventType) {
      case EventType.add:
        List<CartItemModel> newState = List.from(state);
        if(event.cartItem != null) {
          bool found = false;
          for(int i = 0; i < newState.length; i++) {
            if(newState[i].product.id == event.cartItem.product.id){
              newState[i].count += 1;
              found = true;
              break;
            }
          }
          if(!found) {
            newState.add(event.cartItem);
          }
        }
        yield newState;
        break;
      case EventType.remove:
        List<CartItemModel> newState = List.from(state);
        if(event.cartIndex != null) {
          newState.removeAt(event.cartIndex);
        }
        yield newState;
        break;
      case EventType.updateCount:
        List<CartItemModel> newState = List.from(state);
        if(event.cartIndex != null && event.updateCount != null) {
          newState[event.cartIndex].count = event.updateCount;
        }
        yield newState;
        break;
      case EventType.clear:
        List<CartItemModel> newState = [];
        yield newState;
        break;
      default:
        throw Exception('Event no found');
    }
  }
  
}

final cartBloc = CartBloc();