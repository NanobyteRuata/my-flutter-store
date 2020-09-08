import 'package:bloc/bloc.dart';
import 'package:my_store/src/blocs/events/wishlist_event.dart';
import 'package:my_store/src/models/product_model.dart';

class WishListBloc extends Bloc<WishListEvent, List<ProductModel>>{

  WishListBloc() : super([]);

  @override
  Stream<List<ProductModel>> mapEventToState(WishListEvent event) async* {
    switch(event.eventType) {
      case EventType.add:
        List<ProductModel> newState = List.from(state);
        if(event.wishListItem != null) {
            newState.add(event.wishListItem);
        }
        yield newState;
        break;
      case EventType.remove:
        List<ProductModel> newState = List.from(state);
        if(event.wishListItem != null) {
          for(int i = 0; i < newState.length; i++) {
            ProductModel product = newState[i];
            if(product.id == event.wishListItem.id) {
              newState.remove(product);
              break;
            }
          }
        }
        yield newState;
        break;
      default:
        throw Exception('Event no found');
    }
  }

}

final cartBloc = WishListBloc();