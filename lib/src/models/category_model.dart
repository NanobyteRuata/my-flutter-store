import 'package:my_store/src/models/filterable_model.dart';

class CategoryModel {
  String _id;
  String _imageUrl;
  String _name;
  List<Filterable> _filterableList = [];

  CategoryModel(String id, String imageUrl, String name, List<Filterable> filterableList) {
    _id = id;
    _imageUrl = imageUrl;
    _name = name;
    _filterableList = filterableList;
  }

  CategoryModel.fromJson(Map<String,dynamic> jsonObject) {
    _id = jsonObject["id"];
    _imageUrl = jsonObject["image_url"];
    _name = jsonObject["name"];

    List<Filterable> tempFilterableList = [];
    for(int i = 0; i < jsonObject["filterable_list"].length; i++) {
      tempFilterableList.add(new Filterable.fromJson(jsonObject["filterable_list"][i]));
    }
    _filterableList = tempFilterableList;
  }

  String get id => _id;

  String get imageUrl => _imageUrl;

  String get name => _name;

  List<Filterable> get filterableList => _filterableList;
}