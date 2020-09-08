import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_store/src/models/orders_result_model.dart';

class OrderListItemWidget extends StatelessWidget {
  final OrdersResultModel orderDetail;
  final Function onPressed;
  final String statusStr;
  final Color statusColor;

  OrderListItemWidget({Key key, @required this.orderDetail, @required this.onPressed, @required this.statusColor, @required this.statusStr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text("Order ID: " +
                                orderDetail.id),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 8)),
                            Text("Ordered date: " +
                                orderDetail
                                    .orderedDate
                                    .day
                                    .toString() +
                                "." +
                                orderDetail
                                    .orderedDate
                                    .month
                                    .toString() +
                                "." +
                                orderDetail
                                    .orderedDate
                                    .year
                                    .toString())
                          ],
                        )),
                    Container(
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(right: 4),child: Icon(Icons.circle, color: statusColor, size: 12,),),
                          Text(
                            statusStr,
                          )
                        ],),
                    )
                  ],
                ),
                Padding(
                    padding:
                    EdgeInsets.only(top: 16)),
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color: Colors.grey,
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.only(
                                        right: 8)),
                                Expanded(
                                    child: Text(orderDetail
                                        .totalDeliveryTime))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 8)),
                            Row(
                              children: [
                                Icon(
                                  Icons
                                      .format_list_bulleted,
                                  color: Colors.grey,
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.only(
                                        right: 8)),
                                Expanded(
                                    child: Text(orderDetail
                                        .totalItemsCount
                                        .toString() +
                                        " items"))
                              ],
                            )
                          ],
                        )),
                    Text(
                      NumberFormat("###,###,###")
                          .format(
                          orderDetail
                              .totalPrice) +
                          " MMK",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }


}