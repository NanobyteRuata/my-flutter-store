import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';
import 'package:my_store/src/blocs/cart_bloc.dart';
import 'package:my_store/src/blocs/events/cart_event.dart';
import 'package:my_store/src/blocs/events/orderlist_event.dart';
import 'package:my_store/src/blocs/events/wishlist_event.dart';
import 'package:my_store/src/blocs/orderlist_bloc.dart';
import 'package:my_store/src/blocs/wishlist_bloc.dart';
import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/orders_result_model.dart';
import 'package:my_store/src/ui/screens/cart_item.dart';
import 'package:my_store/src/ui/screens/product_detail.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  String mostDelayedDelivery = "";
  int totalAmount = 0;
  int totalCount = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, List<CartItemModel>>(
      builder: (BuildContext context, List<CartItemModel> cartItems) {
        _updateTotals(cartItems);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Cart"),
          ),
          body: Container(
            color: Colors.grey[300],
            child: Column(
              children: [
                Expanded(
                    child: cartItems.length > 0
                        ? ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: InkWell(
                                  child: CartItemWidget(
                                    cartItem: cartItems[index],
                                    onRemove: () => _showRemoveConfirmDialog(
                                        cartItems[index], index),
                                    onCountClicked: () => _showCountPicker(
                                        context, cartItems[index], index),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailWidget(
                                                  productDetail:
                                                      cartItems[index].product,
                                                  fromCart: true,
                                                )));
                                  },
                                ),
                              );
                            })
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart,
                                  color: Colors.grey, size: 60),
                              Text(
                                "Add items to your cart!",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(totalCount.toString() + " items"),
                            Padding(padding: EdgeInsets.only(right: 16)),
                            Expanded(child: Text(mostDelayedDelivery)),
                            Text(
                              NumberFormat("###,###,###").format(totalAmount) +
                                  " MMK",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 4)),
                        Row(
                          children: [
                            Expanded(
                                child: RaisedButton(
                              child: Text(
                                "PLACE ORDER",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.black,
                              onPressed: cartItems.length > 0 ? () => _placeOrder(cartItems) : null,
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateTotals(List<CartItemModel> cartItems) {
    int tempTotalAmount = 0;
    int tempTotalItems = 0;
    int tempMostDelayedDelivery = 0;
    String tempMostDelayedDeliveryStr = "";
    for (int i = 0; i < cartItems.length; i++) {
      CartItemModel item = cartItems[i];
      if (int.parse(item.product.deliveryTime.split("-")[1].split(" ")[0]) >
          tempMostDelayedDelivery) {
        tempMostDelayedDelivery =
            int.parse(item.product.deliveryTime.split("-")[1].split(" ")[0]);
        tempMostDelayedDeliveryStr = item.product.deliveryTime;
      }
      tempTotalAmount += (item.product.discountPrice != null
              ? item.product.discountPrice
              : item.product.price) *
          item.count;
      tempTotalItems += cartItems[i].count;
    }
    totalAmount = tempTotalAmount;
    totalCount = tempTotalItems;
    mostDelayedDelivery = tempMostDelayedDeliveryStr;
  }

  void _showCountPicker(
      BuildContext context, CartItemModel cartItem, int index) {
    showMaterialNumberPicker(
      context: context,
      title: "Pick Count",
      maxNumber: cartItem.product.stock,
      minNumber: 1,
      selectedNumber: cartItem.count,
      onChanged: (value) {
        //TODO: perform update in API

        //Updating Cart Bloc
        BlocProvider.of<CartBloc>(context).add(CartEvent.updateCount(
            index, value));
      },
    );
  }

  void _showRemoveConfirmDialog(CartItemModel item, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Confirm"),
          content: new Text("Removing " + item.product.name + " from cart?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text("Add to Wish List"),
              color: Colors.black,
              onPressed: () {
                _moveToWishList(item, index);
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text("Remove"),
              color: Colors.red,
              onPressed: () {
                _removeCartItem(item, index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _placeOrder(cartItems) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Confirm"),
          content: new Text("Please confirm that you want to place this order."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text("Order"),
              color: Colors.teal,
              onPressed: () {
                BlocProvider.of<OrderListBloc>(context)
                    .add(OrderListEvent.add(new OrdersResultModel("", DateTime.now(), 0, mostDelayedDelivery, totalCount, totalAmount, cartItems)));

                BlocProvider.of<CartBloc>(context).add(CartEvent.clear());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  void _moveToWishList(CartItemModel cartItem, int index) {
    //TODO:add to wish list

    BlocProvider.of<WishListBloc>(context)
        .add(WishListEvent.add(cartItem.product));

    _removeCartItem(cartItem, index);
  }

  void _removeCartItem(CartItemModel cartItem, int index) {
    //TODO: perform update in API

    //Updating Cart Bloc
    BlocProvider.of<CartBloc>(context).add(CartEvent.remove(index));
  }
}
