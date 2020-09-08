import 'package:my_store/src/models/brand_model.dart';
import 'package:my_store/src/models/cart_item_model.dart';
import 'package:my_store/src/models/category_model.dart';
import 'package:my_store/src/models/orders_result_model.dart';
import 'package:my_store/src/models/product_model.dart';

class FakeApi {

  static Future<List<BrandModel>> getAllBrands() async {
    List<BrandModel> brands = [];
    for(int i = 0; i < 8; i++) {
      brands.add(new BrandModel.fromJson({
        "id":"000$i",
        "name":"Brand $i",
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      }));
    }
    return Future.delayed(const Duration(milliseconds: 500), () {
      return brands;
    });
  }

  static Future<List<ProductModel>> getAllProductsWhereCategory(String categoryId) async {
    int intCatId = int.parse(categoryId);

    List<ProductModel> products = [];
    products.add(new ProductModel.fromJson({
      "id":categoryId + "-1",
      "name":"Cat-$intCatId Product 1",
      "images":[
        "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
      ],
      "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_time":"13-15 working days",
      "price":"30000",
      "discount_price": "",
      "category":{
        "id":"000$intCatId",
        "name":"Category $intCatId",
        "filterable_values": [
          {
            "filterable_id":"000" + (intCatId + 0).toString(),
            "filterable_name":"Filterable 1",
            "filterable_value":"Fil 1 Val 1",
          },
          {
            "filterable_id":"000" + (intCatId + 1).toString(),
            "filterable_name":"Filterable 2",
            "filterable_value":"Fil 2 Val 1",
          },
          {
            "filterable_id":"000" + (intCatId + 2).toString(),
            "filterable_name":"Filterable 3",
            "filterable_value":"Fil 3 Val 1",
          },
        ]
      },
      "brand":{
        "id":"000" + (intCatId + 0).toString(),
        "name":"Brand " + (intCatId + 0).toString(),
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      },
      "stock": "5",
    }));
    products.add(new ProductModel.fromJson({
      "id":categoryId + "-2",
      "name":"Cat-$intCatId Product 2",
      "images":[
        "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
      ],
      "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_time":"13-15 working days",
      "price":"30000",
      "discount_price": "25000",
      "category":{
        "id":"000$intCatId",
        "name":"Category $intCatId",
        "filterable_values": [
          {
            "filterable_id":"000" + (intCatId + 0).toString(),
            "filterable_name":"Filterable " + (intCatId + 0).toString(),
            "filterable_value":"Fil " + (intCatId + 0).toString() + " Val 1",
          }
        ]
      },
      "brand":{
        "id":"000" + (intCatId + 1).toString(),
        "name":"Brand " + (intCatId + 1).toString(),
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      },
      "stock": "5",
    }));
    products.add(new ProductModel.fromJson({
      "id":categoryId + "-3",
      "name":"Cat-$intCatId Product 3",
      "images":[
        "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
      ],
      "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_time":"13-15 working days",
      "price":"30000",
      "discount_price": "",
      "category":{
        "id":"000$intCatId",
        "name":"Category $intCatId",
        "filterable_values": [
          {
            "filterable_id":"000" + (intCatId + 1).toString(),
            "filterable_name":"Filterable " + (intCatId + 1).toString(),
            "filterable_value":"Fil " + (intCatId + 1).toString() + " Val 1",
          },
        ]
      },
      "brand":{
        "id":"000" + (intCatId + 1).toString(),
        "name":"Brand " + (intCatId + 1).toString(),
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      },
      "stock": "5",
    }));
    products.add(new ProductModel.fromJson({
      "id":categoryId + "-4",
      "name":"Cat-$intCatId Product 4",
      "images":[
        "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
      ],
      "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_time":"13-15 working days",
      "price":"30000",
      "discount_price": "25000",
      "category":{
        "id":"000$intCatId",
        "name":"Category $intCatId",
        "filterable_values": [
          {
            "filterable_id":"000" + (intCatId + 0).toString(),
            "filterable_name":"Filterable " + (intCatId + 0).toString(),
            "filterable_value":"Fil " + (intCatId + 0).toString() +" Val 1",
          },
          {
            "filterable_id":"000" + (intCatId + 1).toString(),
            "filterable_name":"Filterable " + (intCatId + 1).toString(),
            "filterable_value":"Fil " + (intCatId + 1).toString() +" Val 1",
          },
        ]
      },
      "brand":{
        "id":"000" + (intCatId + 2).toString(),
        "name":"Brand " + (intCatId + 2).toString(),
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      },
      "stock": "5",
    }));
    products.add(new ProductModel.fromJson({
      "id":categoryId + "-5",
      "name":"Cat-$intCatId Product 5",
      "images":[
        "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
      ],
      "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_time":"13-15 working days",
      "price":"30000",
      "discount_price": "",
      "category":{
        "id":"000$intCatId",
        "name":"Category $intCatId",
        "filterable_values": [
          {
            "filterable_id":"000" + (intCatId + 0).toString(),
            "filterable_name":"Filterable " + (intCatId + 0).toString(),
            "filterable_value":"Fil " + (intCatId + 0).toString() +" Val 1",
          },
        ]
      },
      "brand":{
        "id":"000" + (intCatId + 1).toString(),
        "name":"Brand " + (intCatId + 1).toString(),
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      },
      "stock": "5",
    }));
    products.add(new ProductModel.fromJson({
      "id":categoryId + "-6",
      "name":"Cat-$intCatId Product 6",
      "images":[
        "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
      ],
      "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "delivery_time":"13-15 working days",
      "price":"30000",
      "discount_price": "25000",
      "category":{
        "id":"000$intCatId",
        "name":"Category $intCatId",
        "filterable_values": [
          {
            "filterable_id":"000" + (intCatId + 2).toString(),
            "filterable_name":"Filterable " + (intCatId + 2).toString(),
            "filterable_value":"Fil " + (intCatId + 2).toString() +" Val 1",
          },
        ]
      },
      "brand":{
        "id":"000" + (intCatId + 0).toString(),
        "name":"Brand " + (intCatId + 0).toString(),
        "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
      },
      "stock": "5",
    }));
    return Future.delayed(const Duration(milliseconds: 1500), () {
      return products;
    });
}

  static Future<List<ProductModel>> getAllProductsWhereBrand(String brandId) async {
    int intBrId = int.parse(brandId);

    List<ProductModel> products = [];
    List<ProductModel> allProducts = [];
    List<ProductModel> tempProducts = [];

    allProducts = await getAllProductsWhereCategory("00001");
    tempProducts = await getAllProductsWhereCategory("00002");
    allProducts.addAll(tempProducts);
    tempProducts = await getAllProductsWhereCategory("00003");
    allProducts.addAll(tempProducts);

    allProducts.forEach((product) {
      if(int.parse(product.brand.id) == intBrId) {
        products.add(product);
      }
    });

    return products;
  }

  static Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categories = [];
    categories.add(new CategoryModel.fromJson({
      "id":"0001",
      "image_url":"https://images.ctfassets.net/od02wyo8cgm5/6mLHhPkYkIMZrO8ct7HauF/541b2ed65e4fd7909d8e55ba86af0df4/cloud_2-fw19-black_white-m-g1.png?w=1440&h=1440&fl=progressive&q=61&bg=rgb:f7f7f7&fm=jpg",
      "name":"Category 1",
      "filterable_list": [
        {
          "id":"0001",
          "name":"Filterable 1",
          "values":[
            "Fil 1 Val 1",
            "Fil 1 Val 2",
            "Fil 1 Val 3",
          ],
        },
        {
          "id":"0002",
          "name":"Filterable 2",
          "values":[
            "Fil 2 Val 1",
            "Fil 2 Val 2",
            "Fil 2 Val 3",
          ],
        },
        {
          "id":"0003",
          "name":"Filterable 3",
          "values":[
            "Fil 3 Val 1",
            "Fil 3 Val 2",
            "Fil 3 Val 3",
          ],
        },
      ],
    }));
    categories.add(new CategoryModel.fromJson({
      "id":"0002",
      "image_url":"https://images.ctfassets.net/od02wyo8cgm5/6mLHhPkYkIMZrO8ct7HauF/541b2ed65e4fd7909d8e55ba86af0df4/cloud_2-fw19-black_white-m-g1.png?w=1440&h=1440&fl=progressive&q=61&bg=rgb:f7f7f7&fm=jpg",
      "name":"Category 2",
      "filterable_list": [
        {
          "id":"0004",
          "name":"Filterable 4",
          "values":[
            "Fil 4 Val 1",
            "Fil 4 Val 2",
            "Fil 4 Val 3",
          ],
        },
        {
          "id":"0005",
          "name":"Filterable 5",
          "values":[
            "Fil 5 Val 1",
            "Fil 5 Val 2",
            "Fil 5 Val 3",
          ],
        },
        {
          "id":"0006",
          "name":"Filterable 6",
          "values":[
            "Fil 6 Val 1",
            "Fil 6 Val 2",
            "Fil 6 Val 3",
          ],
        },
      ],
    }));
    categories.add(new CategoryModel.fromJson({
      "id":"0003",
      "image_url":"https://images.ctfassets.net/od02wyo8cgm5/6mLHhPkYkIMZrO8ct7HauF/541b2ed65e4fd7909d8e55ba86af0df4/cloud_2-fw19-black_white-m-g1.png?w=1440&h=1440&fl=progressive&q=61&bg=rgb:f7f7f7&fm=jpg",
      "name":"Category 3",
      "filterable_list": [
        {
          "id":"0007",
          "name":"Filterable 7",
          "values":[
            "Fil 7 Val 1",
            "Fil 7 Val 2",
            "Fil 7 Val 3",
          ],
        },
        {
          "id":"0008",
          "name":"Filterable 8",
          "values":[
            "Fil 8 Val 1",
            "Fil 8 Val 2",
            "Fil 8 Val 3",
          ],
        },
        {
          "id":"0009",
          "name":"Filterable 9",
          "values":[
            "Fil 9 Val 1",
            "Fil 9 Val 2",
            "Fil 9 Val 3",
          ],
        },
      ],
    }));
//    categories.add(new CategoryModel.fromJson({
//      "id":"0006",
//      "image_url":"https://images.ctfassets.net/od02wyo8cgm5/6mLHhPkYkIMZrO8ct7HauF/541b2ed65e4fd7909d8e55ba86af0df4/cloud_2-fw19-black_white-m-g1.png?w=1440&h=1440&fl=progressive&q=61&bg=rgb:f7f7f7&fm=jpg",
//      "name":"Category 6",
//      "filterable_list": [
//        {
//          "id":"0013",
//          "name":"Filterable 13",
//          "values":[
//            "Fil 13 Val 1",
//            "Fil 13 Val 2",
//            "Fil 13 Val 3",
//          ],
//        },
//      ],
//    }));
//    categories.add(new CategoryModel.fromJson({
//      "id":"0004",
//      "image_url":"https://images.ctfassets.net/od02wyo8cgm5/6mLHhPkYkIMZrO8ct7HauF/541b2ed65e4fd7909d8e55ba86af0df4/cloud_2-fw19-black_white-m-g1.png?w=1440&h=1440&fl=progressive&q=61&bg=rgb:f7f7f7&fm=jpg",
//      "name":"Category 4",
//      "filterable_list": [
//        {
//          "id":"0010",
//          "name":"Filterable 10",
//          "values":[
//            "Fil 10 Val 1",
//            "Fil 10 Val 2",
//            "Fil 10 Val 3",
//          ],
//        },
//      ],
//    }));
//    categories.add(new CategoryModel.fromJson({
//      "id":"0005",
//      "image_url":"https://images.ctfassets.net/od02wyo8cgm5/6mLHhPkYkIMZrO8ct7HauF/541b2ed65e4fd7909d8e55ba86af0df4/cloud_2-fw19-black_white-m-g1.png?w=1440&h=1440&fl=progressive&q=61&bg=rgb:f7f7f7&fm=jpg",
//      "name":"Category 5",
//      "filterable_list": [
//        {
//          "id":"0011",
//          "name":"Filterable 11",
//          "values":[
//            "Fil 11 Val 1",
//            "Fil 11 Val 2",
//            "Fil 11 Val 3",
//          ],
//        },
//        {
//          "id":"0012",
//          "name":"Filterable 12",
//          "values":[
//            "Fil 12 Val 1",
//            "Fil 12 Val 2",
//            "Fil 12 Val 3",
//          ],
//        },
//      ],
//    }));
    return Future.delayed(const Duration(milliseconds: 500), () {
      return categories;
    });
  }

  static Future<List<ProductModel>> getWishListItems() {
    List<ProductModel> products = [];
    return Future.delayed(const Duration(milliseconds: 500), () {
      return [];
    });
  }

  static Future<List<ProductModel>> getSuggestedItems() {
    List<ProductModel> products = [];
    for(int i = 0; i < 5; i++) {
      products.add(new ProductModel.fromJson({
        "id":"product$i",
        "name":"Product $i",
        "images":[
          "https://d1ekp87k3th824.cloudfront.net/media/catalog/product/cache/24b85352f4d2f651c81fec087949b4a7/e/p/ep_microfiberbl_1.jpg",
          "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
          "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg",
          "https://upload.wikimedia.org/wikipedia/commons/4/44/3-4_ratio_mobile_wallpaper_example.jpg"
        ],
        "details":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "delivery_info":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "delivery_time":"13-15 working days",
        "price":"30000",
        "discount_price": i%2 == 0 ? "" : "25000",
        "category":{
          "id":"001",
          "name":"Category 1",
          "filterable_values": [
            {
              "filterable_id":"001",
              "filterable_name":"Filterable 1",
              "filterable_value":"Fil 1 Val 1",
            },
            {
              "filterable_id":"002",
              "filterable_name":"Filterable 2",
              "filterable_value":"Fil 2 Val 1",
            },
          ]
        },
        "brand":{
          "id":"0001",
          "name":"Brand 1",
          "image_url":"https://s3-eu-central-1.amazonaws.com/centaur-wp/designweek/prod/content/uploads/2016/03/02190943/image7.jpeg"
        },
        "stock": (i + 1).toString()
      }));
    }
    return Future.delayed(const Duration(milliseconds: 500), () {
      return products;
    });
  }

  static Future<List<CartItemModel>> getCartListItems() {
    List<CartItemModel> products = [];
    return Future.delayed(const Duration(milliseconds: 500), () {
      return products;
    });
  }

  static Future<int> getCartItemsCount() async {
    int count = 0;
    List<CartItemModel>  cartItems = await getCartListItems();
    cartItems.forEach((element) {
      count += element.count;
    });
    return count;
  }

  static Future<List<OrdersResultModel>> getOrdersList() {
    List<OrdersResultModel> orders = [];

    return Future.delayed(const Duration(milliseconds: 500), () {
      return orders;
    });

  }
}