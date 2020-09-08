import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/models/category_model.dart';
import 'package:my_store/src/ui/screens/brands.dart';
import 'package:my_store/src/ui/screens/products_list.dart';
import 'package:my_store/src/ui/widgets/square_box.dart';
import 'package:provider/provider.dart';
import 'package:my_store/src/services/connectivity_service.dart';

class CategoriesTabWidget extends StatefulWidget {
  _CategoriesTabWidgetState createState() => _CategoriesTabWidgetState();
}

class _CategoriesTabWidgetState extends State<CategoriesTabWidget> {
  List<CategoryModel> categoriesList = [];

  bool isLoading = true;

  ConnectivityStatus connection;
  @override
  void initState() {
    _getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Auto reload when there is connection
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connection == ConnectivityStatus.Offline && connectionStatus != ConnectivityStatus.Offline) {
      _getAllCategories(); //this updates state but since this is async function, there's no error
    }
    connection = connectionStatus;

    return RefreshIndicator(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: GridView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1),
                    children: [
                      SquareBoxWidget(
                        name: "New Arrival",
                        imageUrl: 'assets/new_box.jpg',
                        isLocalImage: true,
                        onPress: () => _goToNewArrivals(context),
                      ),
                      SquareBoxWidget(
                        name: "Brands",
                        imageUrl: 'assets/brand.jpeg',
                        isLocalImage: true,
                        onPress: () => _goToBrands(context),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    "All Categories",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                categoriesList.length > 0
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1),
                            itemCount: categoriesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SquareBoxWidget(
                                name: categoriesList[index].name,
                                imageUrl: categoriesList[index].imageUrl,
                                onPress: () => _goToProductsList(categoriesList[index]),
                              );
                            }),
                      )
                    : Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 80),
                        child: Center(child: isLoading ? CircularProgressIndicator() : Text("No Data")),
                      ))
              ],
            ),
          ),
        ),
        onRefresh: () async => _getAllCategories());
  }

  void _getAllCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<CategoryModel> tempAllCategories = await FakeApi.getAllCategories();
      setState(() {
        categoriesList = tempAllCategories;
        isLoading = false;
      });
    } on SocketException catch (e) {
      print(e);
    }
  }

  _goToProductsList(CategoryModel category) {
    Navigator.push(context, 
      MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(category: category,))
    );
  }

  void _goToBrands(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => BrandsWidget()));
  }

  void _goToNewArrivals(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(other: "New Arrivals",))
    );
  }
}
