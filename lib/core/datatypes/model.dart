abstract class Model {
  abstract String collection;
  abstract List<String> fields;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    return data;
  }
}
