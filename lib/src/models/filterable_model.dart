class Filterable {
  String _id;
  String _name;
  List<String> _values = [];

  Filterable(String id, String name, List<String> values) {
    _id = id;
    _name = name;
    _values = values;
  }

  Filterable.fromJson(Map<String, dynamic> jsonObject) {
    _id = jsonObject["id"];
    _name = jsonObject["name"];

    List<String> tempValues = [];
    for(int i = 0; i < jsonObject["values"].length; i++){
      tempValues.add(jsonObject["values"][i]);
    }
    _values = tempValues;
  }

  String get id => _id;

  String get name => _name;

  List<String> get values => _values;
}