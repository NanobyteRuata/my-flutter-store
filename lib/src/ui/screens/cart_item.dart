import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_store/src/models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  
  CartItemModel cartItem;
  bool isOrderItem;
  
  Function onRemove;
  Function onCountClicked;
  
  CartItemWidget({Key key, @required this.cartItem, this.onRemove, this.onCountClicked, this.isOrderItem = false}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                      cartItem.product.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                if(onRemove != null) InkWell(
                    child: Icon(Icons.clear),
                    onTap: onRemove)
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Image.network(
                  cartItem.product.images[0],
                  fit: BoxFit.fill,
                  width: 150,
                  height: 200,
                ),
                Padding(
                    padding: EdgeInsets.only(right: 8)),
                Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(cartItem
                                        .product
                                        .deliveryTime),
                                    if (cartItem
                                        .product
                                        .stock <
                                        5)
                                      Padding(
                                          padding:
                                          EdgeInsets.only(
                                              top: 16)),
                                    if (cartItem
                                        .product
                                        .stock <
                                        5 && !isOrderItem)
                                      Text(
                                        cartItem
                                            .product
                                            .stock
                                            .toString() +
                                            " items left",
                                        style: TextStyle(
                                            color: Colors.red),
                                      ),
                                  ],
                                )),
                            if(!isOrderItem) InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(
                                          16, 8, 16, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                        onCountClicked == null ? CrossAxisAlignment.center : CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "Quantity",
                                            style: TextStyle(
                                                color: Colors
                                                    .grey,
                                                fontSize: 12),
                                          ),
                                          Text(
                                              cartItem
                                                  .count
                                                  .toString())
                                        ],
                                      ),
                                    ),
                                    if(onCountClicked != null) Icon(
                                        Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                              onTap: onCountClicked,
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                        ),
                        Text(
                          cartItem.product.details,
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ))
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Row(
              children: [
                Expanded(
                    child: Text(
                      "Per Price",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12),
                    )),
                if(isOrderItem) Text(
                  "Quantity",
                  style: TextStyle(
                      color: Colors.grey, fontSize: 12),
                ),
                Expanded(child: Text(
                  "Total Price",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.grey, fontSize: 12),
                ))
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                      NumberFormat("###,###,###").format(
                          (cartItem
                              .product
                              .discountPrice !=
                              null
                              ? cartItem
                              .product
                              .discountPrice
                              : cartItem
                              .product
                              .price)) +
                          " MMK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                if(isOrderItem) Text(
                  cartItem.count.toString(),
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(
                  NumberFormat("###,###,###").format(
                      ((cartItem
                          .product
                          .discountPrice !=
                          null
                          ? cartItem
                          .product
                          .discountPrice
                          : cartItem
                          .product
                          .price) *
                          cartItem.count)) +
                      " MMK",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
  
}