import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_store/src/blocs/cart_bloc.dart';
import 'package:my_store/src/blocs/events/cart_event.dart';
import 'package:my_store/src/blocs/events/wishlist_event.dart';
import 'package:my_store/src/blocs/wishlist_bloc.dart';
import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/product_model.dart';
import 'package:my_store/src/ui/screens/cart.dart';
import 'package:my_store/src/ui/screens/product_detail.dart';

class ProductGridItemWidget extends StatelessWidget {
  final bool showClearButton;
  final bool showFavouriteButton;
  final bool showAddToCartButton;
  final ProductModel product;

  final Function onClear;
  final Function onAddToCart;

  ProductGridItemWidget(
      {Key key,
      this.showClearButton = false,
      this.showFavouriteButton = false,
      this.showAddToCartButton = false,
      this.onClear,
      this.onAddToCart,
      @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          InkWell(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            child: Image.network(
                              product.images[0],
                              fit: BoxFit.fill,
                              width: 300,
                              height: 400,
                            ),
                          ),
                          if (product.discountPrice != null)
                            Positioned(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Transform.rotate(
                                  angle: 3.14 / 7,
                                  child: Center(
                                    child: Text(
                                      "-" +
                                          NumberFormat("###").format(100 -
                                              ((product.discountPrice /
                                                      product.price) *
                                                  100)) +
                                          "%",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              top: 10,
                              right: 10,
                            ),
                          if (this.showClearButton)
                            Positioned(
                              child: InkWell(
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                    )),
                                onTap: onClear,
                              ),
                              top: 0,
                              right: 0,
                            ),
                          if (this.product.stock == 0)
                            Positioned(
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                child: Transform.rotate(
                                  angle: - 3.14 / 7,
                                  child: Center(
                                    child: Text("Out of Stock",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black),
                    )),
                    if (this.showFavouriteButton)
                      BlocBuilder<CartBloc, List<CartItemModel>>(builder: (BuildContext context, List<CartItemModel> cartState) {
                        bool isFoundInCart = false;
                        cartState.forEach((element) {
                          if(element.product.id == product.id) {
                            isFoundInCart = true;
                          }
                        });
                        return isFoundInCart ? IconButton(icon: Icon(Icons.shopping_cart, color: Colors.teal,), onPressed: () => _goToCart(context)) : BlocBuilder<WishListBloc, List<ProductModel>>(builder:
                            (BuildContext context, List<ProductModel> wishListState) {
                          bool found = false;
                          wishListState.forEach((element) {
                            if(element.id == product.id) {
                              found = true;
                            }
                          });
                          return IconButton(
                              icon: found ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ): Icon(
                                Icons.favorite_outline,
                                color: Colors.black,
                              ),
                              onPressed: () => _addOrRemoveWishList(context,found));
                        });
                      })
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.details,
                        overflow: TextOverflow.ellipsis,
                        maxLines: this.showAddToCartButton ? 2 : 4,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        new NumberFormat("###,###,###", "en_US").format(
                                product.discountPrice != null
                                    ? product.discountPrice
                                    : product.price) +
                            " MMK",
                        style: TextStyle(
                            color: product.discountPrice != null
                                ? Colors.red
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      if (product.discountPrice != null)
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            new NumberFormat("###,###,###", "en_US")
                                    .format(product.price) +
                                " MMK",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
            onTap: () => _navigateToProductDetail(context),
          ),
          if (this.showAddToCartButton)
            Row(
              children: [
                Expanded(
                    child: RaisedButton(
                  child: Text("ADD TO CART"),
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context)
                        .add(CartEvent.add(new CartItemModel(product, 1)));
                    onAddToCart();
                  },
                ))
              ],
            )
        ],
      ),
    );
  }

  void _addOrRemoveWishList(context, bool isInWishList) {
    if(isInWishList) {
      BlocProvider.of<WishListBloc>(context)
          .add(WishListEvent.remove(product));
    } else {
      BlocProvider.of<WishListBloc>(context)
          .add(WishListEvent.add(product));
    }
  }

  void _navigateToProductDetail(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailWidget(productDetail: product),
      ),
    );
  }

  void _goToCart(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartWidget(),
      ),
    );
  }
}
