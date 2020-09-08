import 'package:bloc/bloc.dart';
import 'package:my_store/src/blocs/events/orderlist_event.dart';
import 'package:my_store/src/models/orders_result_model.dart';
import 'package:my_store/src/models/product_model.dart';

class OrderListBloc extends Bloc<OrderListEvent, List<OrdersResultModel>>{

  OrderListBloc() : super([]);

  @override
  Stream<List<OrdersResultModel>> mapEventToState(OrderListEvent event) async* {
    switch(event.eventType) {
      case EventType.add:
        List<OrdersResultModel> newState = List.from(state);
        if(event.ordersResultItem != null) {
          newState.add(event.ordersResultItem);
        }
        yield newState;
        break;
      default:
        throw Exception('Event no found');
    }
  }

}

final cartBloc = OrderListBloc();