import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/blocs/cart_bloc.dart';
import 'package:my_store/src/blocs/events/cart_event.dart';
import 'package:my_store/src/blocs/events/orderlist_event.dart';
import 'package:my_store/src/blocs/events/wishlist_event.dart';
import 'package:my_store/src/blocs/orderlist_bloc.dart';
import 'package:my_store/src/blocs/wishlist_bloc.dart';
import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/category_model.dart';
import 'package:my_store/src/models/orders_result_model.dart';
import 'package:my_store/src/models/product_model.dart';
import 'package:my_store/src/ui/screens/cart.dart';
import 'package:my_store/src/ui/screens/categories_tab.dart';
import 'package:my_store/src/ui/screens/home_tab.dart';
import 'package:my_store/src/ui/screens/orders_tab.dart';
import 'package:my_store/src/ui/screens/search.dart';
import 'package:my_store/src/ui/screens/wishlist_tab.dart';
import 'package:provider/provider.dart';
import 'package:my_store/src/services/connectivity_service.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String title = "Home";

  int selectedTabIndex = 0;

  bool showSearchBar = true;

  bool internetConnection;

  bool isHomeInitialized = false;

  List<ProductModel> wishList = [];
  List<ProductModel> newArrivals = [];
  List<ProductModel> recommendedList = [];
  List<ProductModel> discountList = [];
  List<BrandModel> brandList = [];
  List<OrdersResultModel> ordersResultList = [];
  List<CategoryModel> categoriesList = [];

  StreamSubscription<ConnectivityResult> subscription;

  DateTime currentBackPressTime;

  @override
  void initState() {
    _checkConnection();
    _initTabs();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchWidget(),
                  ),
                );
              }),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              new Positioned(
                right: 0,
                top: 5,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: new Text(
                    '10',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          BlocBuilder<CartBloc, List<CartItemModel>>(
            builder: (BuildContext context, List<CartItemModel> state) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: _navigateToCart),
                  if (state.length > 0)
                    new Positioned(
                        right: 0,
                        top: 5,
                        child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: new Text(
                            state.length.toString(),
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ))
                ],
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Builder(builder: (BuildContext context) {
              switch (selectedTabIndex) {
                case 0:
                  return isHomeInitialized ? RefreshIndicator(child: HomeTabWidget(newArrivalProductsList: newArrivals, brandsList: brandList, recommendedProductsList: recommendedList, discountProductsList: discountList,), onRefresh: () async {
                    setState(() {
                      isHomeInitialized = false;
                    });
                    _initHome();
                  }) : Container(child: Center(child: CircularProgressIndicator(),),);
                  break;
                case 1:
                  return WishListTabWidget();
                  break;
                case 2:
                  return CategoriesTabWidget();
                  break;
                case 3:
                  return OrdersTabWidget(refreshOrders: () async => _initTabs());
                  break;
                case 4:
                  return Center(
                    child: Text("Account"),
                  );
                  break;
                default:
                  return Center(
                    child: Text("Loading"),
                  );
              }
            }),
          ),
          if(connectionStatus == ConnectivityStatus.Offline) Positioned(
            child: Container(
              height: 30,
              child: Center(
                child: Text(
                  "No Internet",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: Colors.black.withOpacity(0.5),
            ),
            top: 0,
            left: 0,
            right: 0,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text("Wish List")),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), title: Text("Categories")),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list), title: Text("Orders")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Account")),
        ],
        currentIndex: selectedTabIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        onTap: _onTabChange,
      ),
    ), onWillPop: _onWillPop);
  }

  void _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetConnection = true;
      }
    } on SocketException catch (_) {
      internetConnection = false;
    }
  }

  void _onTabChange(int tabIndex) {
    String tempTitle;
    int tempSelectedTabIndex;
    switch (tabIndex) {
      case 0:
        tempTitle = "Home";
        tempSelectedTabIndex = 0;
        break;
      case 1:
        tempTitle = "Wish List";
        tempSelectedTabIndex = 1;
        break;
      case 2:
        tempTitle = "Categories";
        tempSelectedTabIndex = 2;
        break;
      case 3:
        tempTitle = "Orders";
        tempSelectedTabIndex = 3;
        break;
      case 4:
        tempTitle = "Account";
        tempSelectedTabIndex = 4;
        break;
    }
    setState(() {
      title = tempTitle;
      selectedTabIndex = tempSelectedTabIndex;
    });
  }

  void _initTabs() async {
    //Init home
    _initHome();

    //Get all wish list items
    List<ProductModel> tempWishLists = await FakeApi.getWishListItems();
    tempWishLists.forEach((element) {
      BlocProvider.of<WishListBloc>(context).add(WishListEvent.add(element));
    });

    //Get all cart items
    List<CartItemModel> tempCartItems = await FakeApi.getCartListItems();
    tempCartItems.forEach((element) {
      BlocProvider.of<CartBloc>(context).add(CartEvent.add(element));
    });

    //Get all order items
    List<OrdersResultModel> tempOrderItems = await FakeApi.getOrdersList();
    tempOrderItems.forEach((element) {
      BlocProvider.of<OrderListBloc>(context).add(OrderListEvent.add(element));
    });
  }

  _initHome() async {
    //Get all new arrival items
    List<ProductModel> tempNewArrivals = await FakeApi.getAllProductsWhereCategory("00001");
    List<BrandModel> tempBrands = await FakeApi.getAllBrands();
    List<ProductModel> tempRecommended = await FakeApi.getAllProductsWhereCategory("00001");
    List<ProductModel> tempDiscounts = await FakeApi.getAllProductsWhereCategory("00001");
    setState(() {
      newArrivals = tempNewArrivals;
      brandList = tempBrands;
      recommendedList = tempRecommended;
      discountList = tempDiscounts;
      isHomeInitialized = true;
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartWidget(),
      ),
    );
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
