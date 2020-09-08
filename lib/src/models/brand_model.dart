class BrandModel {
  String _id;
  String _name;
  String _imageUrl;

  BrandModel.fromJson(Map<String, dynamic> jsonObject) {
    _id = jsonObject["id"];
    _name = jsonObject["name"];
    _imageUrl = jsonObject["image_url"];
  }

  String get id => _id;

  String get name => _name;

  String get imageUrl => _imageUrl;
}