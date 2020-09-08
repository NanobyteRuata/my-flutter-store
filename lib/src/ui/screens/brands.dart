import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/ui/screens/products_list.dart';
import 'package:my_store/src/ui/widgets/square_box.dart';
import 'package:provider/provider.dart';
import 'package:my_store/src/services/connectivity_service.dart';

class BrandsWidget extends StatefulWidget {
  BrandsWidget({Key key}) : super(key: key);

  _BrandsWidgetState createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends State<BrandsWidget> {

  List<BrandModel> brandsList = [];

  bool isLoading = true;
  ConnectivityStatus connection;

  @override
  void initState() {
    super.initState();
    _getAllBrands();
  }

  @override
  Widget build(BuildContext context) {
    //Auto reload when there is connection
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connection == ConnectivityStatus.Offline && connectionStatus != ConnectivityStatus.Offline) {
      _getAllBrands(); //this updates state but since this is async function, there's no error
    }
    connection = connectionStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text("Brands"),
      ),
      body: Stack( children: [Container(
        child: brandsList.length > 0 ? Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1),
              itemCount: brandsList.length,
              itemBuilder: (BuildContext context, int index) {
                return SquareBoxWidget(
                  name: brandsList[index].name,
                  imageUrl: brandsList[index].imageUrl,
                  onPress: () => _goToProductsList(brandsList[index]),
                );
              }),
        ) : Center(child: isLoading ? CircularProgressIndicator() : Text("No Data"),),
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
    )]));
  }

  void _getAllBrands() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<BrandModel> tempAllBrands = await FakeApi.getAllBrands();
      setState(() {
        brandsList = tempAllBrands;
        isLoading = false;
      });
    } on SocketException catch(e) {
      print(e.message);
    }
  }

  _goToProductsList(BrandModel brand) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(brand: brand,))
    );
  }
}
