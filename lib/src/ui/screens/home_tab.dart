import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/models/product_model.dart';
import 'package:my_store/src/ui/screens/brands.dart';
import 'package:my_store/src/ui/screens/product_detail.dart';
import 'package:my_store/src/ui/screens/products_list.dart';
import 'package:my_store/src/ui/widgets/product_grid_item.dart';

class HomeTabWidget extends StatelessWidget {
  final List<ProductModel> newArrivalProductsList;
  final List<BrandModel> brandsList;
  final List<ProductModel> discountProductsList;
  final List<ProductModel> recommendedProductsList;

  HomeTabWidget({Key key, @required this.newArrivalProductsList, @required this.discountProductsList, @required this.recommendedProductsList, @required this.brandsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
              child: Container(
              color: Colors.white,
              child: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Row(
                      children: [
                        Expanded(child: Text("New Arrivals", style: TextStyle(fontSize: 16),)),
                        IconButton(
                            icon: Icon(Icons.arrow_forward), onPressed: () => _goToNewArrivals(context))
                      ],
                    ),),
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: newArrivalProductsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: ProductGridItemWidget(
                                        product: newArrivalProductsList[index]),
                                  ),
                                );
                              })
                    )
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 2), child: Container(color: Colors.white, child: Column(children: [
              Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Row(
                children: [
                  Expanded(child: Text("Brands", style: TextStyle(fontSize: 16),)),
                  IconButton(
                      icon: Icon(Icons.arrow_forward), onPressed: () => _goToBrands(context))
                ],
              ),),
              Container(height: 230, child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1),
                  itemCount: brandsList.length,
                  itemBuilder: (BuildContext context, int index) {
                return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                    InkWell(child:Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle,image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            brandsList[index].imageUrl)
                    ))), onTap: () => _goToProductsList(brandsList[index], context),),
                  Text(brandsList[index].name)
                ],);
              }))
            ],),),),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Row(
                      children: [
                        Expanded(child: Text("Recommended", style: TextStyle(fontSize: 16),)),
                        IconButton(
                            icon: Icon(Icons.arrow_forward), onPressed: () => _goToRecommendedList(context))
                      ],
                    ),),
                    Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedProductsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(child: Container(
                                width: 250,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(children: [
                                    Container(width: 100, height: 150, child: Image.network(recommendedProductsList[index].images[0]),),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(recommendedProductsList[index].name, style: TextStyle(fontSize: 16),),
                                        Text(recommendedProductsList[index].details, overflow: TextOverflow.ellipsis, maxLines: 4, style: TextStyle(fontSize: 12, color: Colors.grey),)
                                      ],))
                                  ],),
                                ),
                              ),
                              onTap: () => _goToProductDetail(recommendedProductsList[index], context),);
                            })
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Row(
                      children: [
                        Expanded(child: Text("Discounts", style: TextStyle(fontSize: 16),)),
                        IconButton(
                            icon: Icon(Icons.arrow_forward), onPressed: () => _goToDiscount(context))
                      ],
                    ),),
                    Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: discountProductsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: 200,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ProductGridItemWidget(
                                      product: discountProductsList[index]),
                                ),
                              );
                            })
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToNewArrivals(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(other: "New Arrivals",))
    );
  }

  void _goToDiscount(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(other: "Discounts",))
    );
  }

  void _goToBrands(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => BrandsWidget()));
  }

  void _goToProductsList(BrandModel brand, context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(brand: brand,))
    );
  }

  void _goToRecommendedList(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductsListWidget(other: "Recommended",))
    );
  }

  void _goToProductDetail(ProductModel product, context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProductDetailWidget(productDetail: product,))
    );
  }
}
