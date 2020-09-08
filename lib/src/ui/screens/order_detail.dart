import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_store/src/models/orders_result_model.dart';
import 'package:my_store/src/ui/screens/cart_item.dart';
import 'package:my_store/src/ui/screens/product_detail.dart';

class OrderDetailWidget extends StatelessWidget {

  OrdersResultModel orderDetail;

  OrderDetailWidget({Key key, @required this.orderDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String statusStr;
    Color statusColor;
    switch(orderDetail.status){
      case 0: statusStr = "In Progress"; statusColor = Colors.orange; break;
      case 1: statusStr = "Delivering"; statusColor = Colors.blue; break;
      case 2: statusStr = "Received"; statusColor = Colors.green; break;
    }
    return Scaffold(appBar: AppBar(title: Text(orderDetail.id), bottom: PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: Container(
          child: Padding(padding: EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(children: [
              Expanded(child: Text("Ordered date: " + orderDetail.orderedDate.day.toString() + "." + orderDetail.orderedDate.month.toString() + "." + orderDetail.orderedDate.year.toString(), style: TextStyle(color: Colors.white),)),
              Text(statusStr, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),)
            ],),
            Padding(padding: EdgeInsets.only(top: 8)),
            Text( orderDetail.totalItemsCount.toString() + " items", style: TextStyle(color: Colors.white),),
            Padding(padding: EdgeInsets.only(top: 8)),
            Row(children: [
              Expanded(child: Text(orderDetail.totalDeliveryTime, style: TextStyle(color: Colors.white),)),
              Text(NumberFormat("###,###,###").format(orderDetail.totalPrice) + " MMK", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
            ],),
          ],),),
        ),
      ),
    ),),
    body: Container(
      color: Colors.grey[300],
      child: ListView.builder(
        itemCount: orderDetail.orderItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 4),
            child: InkWell(
              child: CartItemWidget(cartItem: orderDetail.orderItems[index], isOrderItem: true,),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailWidget(
                          productDetail:
                          orderDetail.orderItems[index].product,
                          fromOrderDetail: true,
                        )));
              },
            ),
          );
        }),),);
  }

}