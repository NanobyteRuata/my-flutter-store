import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_store/src/blocs/orderlist_bloc.dart';
import 'package:my_store/src/models/orders_result_model.dart';
import 'package:my_store/src/ui/screens/order_detail.dart';

import 'package:my_store/src/ui/widgets/order_list_item.dart';

class OrdersTabWidget extends StatefulWidget {

  final Function refreshOrders;

  OrdersTabWidget({Key key, @required this.refreshOrders}) : super(key: key);

  _OrdersTabWidgetState createState() => _OrdersTabWidgetState();
}

class _OrdersTabWidgetState extends State<OrdersTabWidget> {
  List<OrdersResultModel> filteredList;

  bool chkInProcess = false;
  bool chkDelivering = false;
  bool chkReceived = false;

  bool isLoading = false;

  @override
  void initState() {
//    _initOrdersResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(child: BlocBuilder<OrderListBloc, List<OrdersResultModel>>(
        builder: (BuildContext context, List<OrdersResultModel> state) {

          List<OrdersResultModel> showOrderList =
          filteredList != null ? filteredList : state;

          return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
                color: Colors.grey[300],
                child: state.length > 0
                    ? Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("In Progress"),
                                    Checkbox(value: chkInProcess)
                                  ]),
                              onTap: () => _changeChkValue(0, state),
                            )),
                            Expanded(
                                child: InkWell(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Delivering"),
                                    Checkbox(value: chkDelivering)
                                  ]),
                              onTap: () => _changeChkValue(1, state),
                            )),
                            Expanded(
                                child: InkWell(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Received"),
                                    Checkbox(value: chkReceived)
                                  ]),
                              onTap: () => _changeChkValue(2, state),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: showOrderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              String statusStr;
                              Color statusColor;
                              switch (showOrderList[index].status) {
                                case 0:
                                  statusStr = "In Progress";
                                  statusColor = Colors.orange;
                                  break;
                                case 1:
                                  statusStr = "Delivering";
                                  statusColor = Colors.blue;
                                  break;
                                case 2:
                                  statusStr = "Received";
                                  statusColor = Colors.green;
                                  break;
                              }
                              return OrderListItemWidget(orderDetail: showOrderList[index], onPressed: () => _navigateToOrderDetail(showOrderList[index]), statusColor: statusColor, statusStr: statusStr);
                            }))
                  ],
                ) : SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(),child: Padding(padding: EdgeInsets.only(top: 80),child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading ? CircularProgressIndicator() : Icon(Icons.view_list, color: Colors.grey, size: 60),
                    if(!isLoading) Text(
                      "Make some orders!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),),
                ),
              );}), onRefresh: widget.refreshOrders,);
  }

  void _changeChkValue(int val, ordersResultList) {
    //Update checkbox change
    switch (val) {
      case 0:
        chkInProcess = !chkInProcess;
        break;
      case 1:
        chkDelivering = !chkDelivering;
        break;
      case 2:
        chkReceived = !chkReceived;
        break;
    }

    //Filtering from checkbox
    List<OrdersResultModel> tempOrdersResultList = [];

    if (chkInProcess) {
      ordersResultList.forEach((order) {
        if (order.status == 0) {
          tempOrdersResultList.add(order);
        }
      });
    }

    if (chkDelivering) {
      ordersResultList.forEach((order) {
        if (order.status == 1) {
          tempOrdersResultList.add(order);
        }
      });
    }

    if (chkReceived) {
      ordersResultList.forEach((order) {
        if (order.status == 2) {
          tempOrdersResultList.add(order);
        }
      });
    }

    setState(() {
      if (!chkInProcess && !chkDelivering && !chkReceived) {
        filteredList = null;
      } else {
        filteredList = tempOrdersResultList;
      }
    });
  }

  void _navigateToOrderDetail(OrdersResultModel orderDetail) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderDetailWidget(orderDetail: orderDetail)));
  }
}
