import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/blocs/cart_bloc.dart';
import 'package:my_store/src/blocs/events/cart_event.dart';
import 'package:my_store/src/blocs/events/wishlist_event.dart';
import 'package:my_store/src/blocs/wishlist_bloc.dart';
import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/product_model.dart';
import 'package:my_store/src/ui/screens/cart.dart';
import 'package:my_store/src/ui/widgets/product_grid_item.dart';

class ProductDetailWidget extends StatefulWidget {
  final ProductModel productDetail;
  final bool fromCart;
  final bool fromOrderDetail;

  ProductDetailWidget(
      {Key key,
      @required this.productDetail,
      this.fromCart = false,
      this.fromOrderDetail = false})
      : super(key: key);

  @override
  _ProductDetailWidgetState createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  List<NetworkImage> images;
  List<ProductModel> suggestedProducts;

  @override
  void initState() {
    _initNetworkImages();
    _initSuggestedProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productDetail.name),
        actions: [
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (4 / 3),
                    width: MediaQuery.of(context).size.width,
                    child: images == null
                        ? Center(
                            child: Text("Loading..."),
                          )
                        : Carousel(
                            images: images,
                            dotBgColor: Colors.transparent,
                            dotColor: Colors.black,
                            dotIncreasedColor: Colors.teal,
                            autoplay: false,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Container(
                        color: Colors.white,
                        child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "Details",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "Delivery Info",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 300,
                                  child: TabBarView(children: [
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child:
                                            Text(widget.productDetail.details),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.local_shipping),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                ),
                                                Text(widget
                                                    .productDetail.deliveryTime)
                                              ],
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 16)),
                                            Text(widget
                                                .productDetail.deliveryInfo)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                )
                              ],
                            ))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      color: Colors.white,
                      child: suggestedProducts == null
                          ? Center(
                              child: Text("Loading..."),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: suggestedProducts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: ProductGridItemWidget(
                                        showClearButton: false,
                                        showAddToCartButton: false,
                                        showFavouriteButton: false,
                                        product: suggestedProducts[index]),
                                  ),
                                );
                              }),
                    ),
                  )
                ],
              ),
            )),
            Container(
              color: Colors.white,
              height: 73,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: widget.fromOrderDetail
                            ? CrossAxisAlignment.stretch
                            : CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            new NumberFormat("###,###,###").format(
                                    (widget.productDetail.discountPrice == null
                                        ? widget.productDetail.price
                                        : widget.productDetail.discountPrice)) +
                                " MMK",
                            textAlign: widget.fromOrderDetail
                                ? TextAlign.right
                                : TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.productDetail.discountPrice == null
                                        ? Colors.black
                                        : Colors.red),
                          ),
                          if (widget.productDetail.discountPrice != null)
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                NumberFormat("###,###,###")
                                        .format(widget.productDetail.price) +
                                    " MMK",
                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            )
                        ],
                      ),
                    ),
                    if (!widget.fromOrderDetail)
                      BlocBuilder<CartBloc, List<CartItemModel>>(builder:
                          (BuildContext context, List<CartItemModel> state) {
                        List<CartItemModel> tempCartItems = state;
                        bool isInCart = false;
                        tempCartItems.forEach((element) {
                          if (element.product.id == widget.productDetail.id) {
                            isInCart = true;
                          }
                        });
                        return BlocBuilder<WishListBloc,
                            List<ProductModel>>(
                            builder: (BuildContext context,
                                List<ProductModel> state) {
                              bool isInWishList = false;
                              state.forEach((element) {
                                if (element.id == widget.productDetail.id) {
                                  isInWishList = true;
                                }
                              });
                              return Row(
                          children: [
                            if (!isInCart)
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: InkWell(
                                      child: isInWishList
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_outline,
                                              color: Colors.black,
                                            ),
                                      onTap: () =>
                                          _addOrRemoveWishList(context, isInWishList))
                              ),
                            widget.productDetail.stock > 0 ? isInCart
                                ? RaisedButton(
                                child: Text(
                                  "GO TO CART",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.teal,
                                onPressed: _navigateToCart)
                                : RaisedButton(
                                child: Text(
                                  "ADD TO CART",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.black,
                                onPressed: () => _addToCart(context, isInWishList)) :
                            RaisedButton(
                                child: Text(
                                  "OUT OF STOCK",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.black,
                                onPressed: null)
                          ],
                        );
                      });
                          }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _initNetworkImages() {
    List<NetworkImage> tempImages = [];
    widget.productDetail.images.forEach((element) {
      tempImages.add(NetworkImage(element));
    });
    images = tempImages;
  }

  void _initSuggestedProducts() async {
    List<ProductModel> tempSuggestedItems = await FakeApi.getSuggestedItems();
    setState(() {
      suggestedProducts = tempSuggestedItems;
    });
  }

  void _addOrRemoveWishList(context, bool isInWishList) {
    if (isInWishList) {
      BlocProvider.of<WishListBloc>(context)
          .add(WishListEvent.remove(widget.productDetail));
    } else {
      BlocProvider.of<WishListBloc>(context)
          .add(WishListEvent.add(widget.productDetail));
    }
  }

  void _addToCart(context, bool isInWishList) {
    //TODO: add to cart api request

    //Remove from wish list if exists
    if(isInWishList) {
      BlocProvider.of<WishListBloc>(context)
          .add(WishListEvent.remove(widget.productDetail));
    }

    //Update global state (bloc)
    BlocProvider.of<CartBloc>(context)
        .add(CartEvent.add(new CartItemModel(widget.productDetail, 1)));
  }

  void _navigateToCart() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CartWidget()));
  }
}
