import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/blocs/events/wishlist_event.dart';
import 'package:my_store/src/blocs/wishlist_bloc.dart';
import 'package:my_store/src/models/product_model.dart';
import 'package:my_store/src/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';
import 'package:my_store/src/services/connectivity_service.dart';

class WishListTabWidget extends StatefulWidget {

  @override
  _WishListTabWidgetState createState() => _WishListTabWidgetState();
}

class _WishListTabWidgetState extends State<WishListTabWidget> {
  List<ProductModel> wishList = [];

  bool isLoading = true;

  ConnectivityStatus connection;
  @override
  void initState() {
    _getAllWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Auto reload when there is connection
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connection == ConnectivityStatus.Offline && connectionStatus != ConnectivityStatus.Offline) {
      _getAllWishList(); //this updates state but since this is async function, there's no error
    }
    connection = connectionStatus;

    return RefreshIndicator(
        child: BlocBuilder<WishListBloc, List<ProductModel>>(
            builder: (BuildContext context, List<ProductModel> state) {
              return state.length > 0 ? Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1 / 2.08),
              itemCount: state.length,
              itemBuilder: (BuildContext context, index) {
                return ProductGridItemWidget(
                  showAddToCartButton: true,
                  showClearButton: true,
                  onClear: () =>
                      _showRemoveConfirmDialog(state[index], index),
                  onAddToCart: () => _addProductToCart(state[index]),
                  product: state[index],
                );
              },
            )))
            : Container(
            width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[300],
        child:SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              isLoading ? CircularProgressIndicator() : Icon(Icons.favorite_border, color: Colors.grey, size: 60),
              if(!isLoading) Text(
                "Add items to your wish list!",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),));}),
    onRefresh: () async => _getAllWishList(),);
  }

  void _getAllWishList() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<ProductModel> tempWishList = await FakeApi.getWishListItems();
      setState(() {
        wishList = tempWishList;
        isLoading = false;
      });
    } on SocketException catch (e) {
      print(e.message);
    }
  }

  void _showRemoveConfirmDialog(ProductModel product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Confirm"),
          content: new Text("Removing " + product.name + " from wish list?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text("Yes"),
              color: Colors.red,
              onPressed: () {
                _removeWishListItem(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeWishListItem(ProductModel product) {
    BlocProvider.of<WishListBloc>(context)
        .add(WishListEvent.remove(product));
  }

  void _addProductToCart(ProductModel product) {
    //TODO: Add product to cart api request

    _removeWishListItem(product);
  }
}
