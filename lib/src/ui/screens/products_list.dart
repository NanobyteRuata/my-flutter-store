import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_store/src/api/fake_api.dart';
import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/models/category_model.dart';
import 'package:my_store/src/models/product_model.dart';
import 'package:my_store/src/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';
import 'package:my_store/src/services/connectivity_service.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class ProductsListWidget extends StatefulWidget {
  final CategoryModel category;
  final BrandModel brand;
  final String other;

  ProductsListWidget({Key key, this.category, this.brand, this.other}) : super(key: key);

  @override
  _ProductsListWidgetState createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  String title = "";
  List<ProductModel> productsList = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true;

  ConnectivityStatus connection;

  List<bool> expansionList = [];

  List<FilterableValueModel> selectedFilterables = [];

  List<BrandModel> brandsList = [];
  List<BrandModel> selectedBrands = [];

  List<ProductCategoryModel> categoryList = [];
  List<ProductCategoryModel> selectedCategories = [];

  @override
  void initState() {
    List<bool> tempExpansionList = [];

    //for category type
    if (widget.category != null) {
      title = widget.category.name;

      //Init expansion data
      tempExpansionList.add(false); //1 for brands
      widget.category.filterableList.forEach((element) {
        tempExpansionList.add(false);
      });
      expansionList = tempExpansionList;
    } else if (widget.brand != null) {
      title = widget.brand.name;
    }

    _getProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Auto reload when there is connection
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connection == ConnectivityStatus.Offline &&
        connectionStatus != ConnectivityStatus.Offline) {
      _getProducts(); //this updates state but since this is async function, there's no error
    }
    connection = connectionStatus;

    List<ProductModel> showList = [];
    if (filteredProducts.length > 0 ||
        (selectedFilterables.length > 0 && filteredProducts.length == 0)) {
      showList = filteredProducts;
    } else {
      showList = productsList;
    }

    if(widget.other != null) {
      return Scaffold(appBar: AppBar(title: Text(widget.other),),
      body: Stack(children: [
        Container(
          child: showList.length > 0
              ? Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1 / 2.08),
                itemCount: showList.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ProductGridItemWidget(
                      product: showList[index],
                      showFavouriteButton: true,
                    ),
                  );
                },
              ),
            ),
          )
              : Center(
            child:
            isLoading ? CircularProgressIndicator() : Text("No Data"),
          ),
        ),
        if (connectionStatus == ConnectivityStatus.Offline)
          Positioned(
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
      ]),);
    }

    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Text("Filter"),
            ),
            Expanded(
                child: widget.category != null ? (SingleChildScrollView(
              child: Container(
                child: brandsList.length > 0 ? ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        List<bool> tempExpansionList = expansionList;
                        tempExpansionList[index] = !isExpanded;
                        expansionList = tempExpansionList;
                      });
                    },
                    children: [
                      ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text("Brands"),
                            );
                          },
                          body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: brandsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool isSelected = false;
                                selectedBrands.forEach((element) {
                                  if (element.id == brandsList[index].id) {
                                    isSelected = true;
                                  }
                                });
                                return ListTile(
                                    title: Text(brandsList[index].name),
                                    trailing: isSelected
                                        ? Icon(Icons.check)
                                        : Container(
                                            width: 0,
                                          ),
                                    onTap: () {
                                      List<BrandModel> tempBrands = [];
                                      bool exists = false;
                                      selectedBrands.forEach((element) {
                                        if(element.id == brandsList[index].id) {
                                          exists = true;
                                        }
                                      });
                                      if(!exists) {
                                        tempBrands.add(brandsList[index]);
                                      }
                                      setState(() {
                                        selectedBrands = tempBrands;
                                        _filterProducts();
                                      });
                                    });
                              }),
                      isExpanded: expansionList[0]),
                      for (int i = 0;
                          i < widget.category.filterableList.length;
                          i++)
                        ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(
                                    widget.category.filterableList[i].name),
                              );
                            },
                            body: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget
                                    .category.filterableList[i].values.length,
                                itemBuilder: (BuildContext context, int index) {
                                  bool isSelected = false;
                                  selectedFilterables.forEach((element) {
                                    if (element.filterableId ==
                                            widget.category.filterableList[i]
                                                .id &&
                                        element.filterableValue ==
                                            widget.category.filterableList[i]
                                                .values[index]) {
                                      isSelected = true;
                                    }
                                  });
                                  return ListTile(
                                    title: Text(widget.category
                                        .filterableList[i].values[index]),
                                    trailing: isSelected
                                        ? Icon(Icons.check)
                                        : Container(
                                            width: 0,
                                          ),
                                    onTap: () {
                                      List<FilterableValueModel>
                                          tempSelectedFilterables =
                                          selectedFilterables;
                                      if (isSelected) {
                                        for (int idx = 0;
                                            idx <
                                                tempSelectedFilterables.length;
                                            idx++) {
                                          if (tempSelectedFilterables[idx]
                                                      .filterableId ==
                                                  widget.category
                                                      .filterableList[i].id &&
                                              tempSelectedFilterables[idx]
                                                      .filterableValue ==
                                                  widget
                                                      .category
                                                      .filterableList[i]
                                                      .values[index]) {
                                            tempSelectedFilterables
                                                .removeAt(idx);
                                          }
                                        }
                                      } else {
                                        tempSelectedFilterables.add(
                                            new FilterableValueModel(
                                                widget.category
                                                    .filterableList[i].id,
                                                widget.category
                                                    .filterableList[i].name,
                                                widget
                                                    .category
                                                    .filterableList[i]
                                                    .values[index]));
                                      }

                                      setState(() {
                                        selectedFilterables =
                                            tempSelectedFilterables;
                                        _filterProducts();
                                      });
                                    },
                                  );
                                }),
                            isExpanded: expansionList[i+1])
                    ]) : Container(child: Center(child: Text("Loading..."),),)))) :
                widget.brand != null ? categoryList.length > 0 ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = false;
                      selectedCategories.forEach((element) {
                        if (element.id == categoryList[index].id) {
                          isSelected = true;
                        }
                      });
                      return ListTile(
                          title: Text(categoryList[index].name),
                          trailing: isSelected
                              ? Icon(Icons.check)
                              : Container(
                            width: 0,
                          ),
                          onTap: () {
                            List<ProductCategoryModel> tempCategories = [];
                            bool exists = false;
                            selectedCategories.forEach((element) {
                              if(element.id == categoryList[index].id) {
                                exists = true;
                              }
                            });
                            if(!exists) {
                              tempCategories.add(categoryList[index]);
                            }
                            setState(() {
                              selectedCategories = tempCategories;
                              _filterProducts();
                            });
                          });
                    }) : Container(child: Center(child: Text("Loading..."),),) :
                Container(),
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(title),
        actions: [
          if(widget.other == null) Builder(
            builder: (context) => IconButton(
              icon: Icon(FontAwesome.sliders),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Container(
          child: showList.length > 0
              ? Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1 / 2.08),
                      itemCount: showList.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: ProductGridItemWidget(
                            product: showList[index],
                            showFavouriteButton: true,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child:
                      isLoading ? CircularProgressIndicator() : Text("No Data"),
                ),
        ),
        if (connectionStatus == ConnectivityStatus.Offline)
          Positioned(
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
      ]),
    );
  }

  _getProducts() async {
    try {
      List<ProductModel> tempProducts = [];
      if(widget.category != null)
        tempProducts = await FakeApi.getAllProductsWhereCategory(widget.category.id);
      else if (widget.brand != null)
        tempProducts = await FakeApi.getAllProductsWhereBrand(widget.brand.id);
      else if (widget.other != null && widget.other == "New Arrivals")
        tempProducts = await FakeApi.getAllProductsWhereCategory("00001"); //TODO: get real new arrivals from api
      else if (widget.other != null && widget.other == "Discounts")
        tempProducts = await FakeApi.getAllProductsWhereCategory("00001"); //TODO: get real new discounts from api
      else if (widget.other != null && widget.other == "Recommended")
        tempProducts = await FakeApi.getAllProductsWhereCategory("00001"); //TODO: get real recommended from api
      setState(() {
        productsList = tempProducts;
        isLoading = false;
        if(widget.category != null) _initBrands();
        if(widget.brand != null) _initCategories();
      });
    } on SocketException catch (e) {
      print(e);
    }
  }

  _initBrands() {
    List<BrandModel> tempBrands = [];
    productsList.forEach((product) {
      bool found = false;
      for(int i = 0; i < tempBrands.length; i++) {
        if(tempBrands[i].id == product.brand.id) {
          found = true;
        }
      }
      if(!found) {
        tempBrands.add(product.brand);
      }
    });
    setState(() {
      brandsList = tempBrands;
    });
  }

  _initCategories() {
    List<ProductCategoryModel> tempCategories = [];
    productsList.forEach((product) {
      bool found = false;
      for(int i = 0; i < tempCategories.length; i++) {
        if(int.parse(tempCategories[i].id) == int.parse(product.category.id)) {
          found = true;
        }
      }
      if(!found) {
        tempCategories.add(product.category);
      }
    });
    setState(() {
      categoryList = tempCategories;
    });
  }

  _filterProducts() {
    List<ProductModel> tempFilteredProducts = [];
    for(int productIndex = 0; productIndex < productsList.length; productIndex++) {
      ProductModel product = productsList[productIndex];

      if(widget.category != null) {
        bool foundInBrands = false;
        bool foundInFilters = false;

        if(selectedBrands.length > 0) {
          selectedBrands.forEach((selectedBrand) {
            if(selectedBrand.id == product.brand.id) {
              foundInBrands = true;
            }
          });
        } else {
          foundInBrands = true;
        }

        if(selectedFilterables.length > 0) {
          selectedFilterables.forEach((selectedFilterable) {
            product.category.filterableValues.forEach((filterableValue) {
              if(selectedFilterable.filterableId == filterableValue.filterableId) {
                foundInFilters = true;
              }
            });
          });
        } else {
          foundInFilters = true;
        }

        if(foundInBrands && foundInFilters) {
          tempFilteredProducts.add(product);
        }
      } else if (widget.brand != null) {
        bool foundCategories = false;

        if(selectedCategories.length > 0) {
          selectedCategories.forEach((selectedBrand) {
            if(selectedBrand.id == product.category.id) {
              foundCategories = true;
            }
          });
        } else {
          foundCategories = true;
        }

        if(foundCategories) {
          tempFilteredProducts.add(product);
        }
      }

    }

    setState(() {
      filteredProducts = tempFilteredProducts;
    });
  }
}
