import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Database> databases = [
  LocalDatabase(),
];

abstract class Database {
  static Database getDatabase() {
    return databases[0];
  }

  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    var instance = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results = [];
    var resultsData = instance.getString(collection);
    if (resultsData != null) {
      results = jsonDecode(resultsData);
    }

    return results;
  }

  Future<Map<String, dynamic>?> getById(String collection, dynamic id) async {
    Map<String, dynamic>? data;
    var results = await getAll(collection);
    if (results.isNotEmpty) {
      for (var result in results) {
        if (result['id'] == id) {
          data = result;
          break;
        }
      }
    }
    return data;
  }

  Future<Map<String, dynamic>?> getItemWhereEqual(
      String collection, String key, dynamic value) async {
    Map<String, dynamic>? item;
    return item;
  }

  Future<List<Map<String, dynamic>>> getItemsWhereEqual(
      String collection, String key, dynamic value) async {
    List<Map<String, dynamic>> items = [];
    return items;
  }

  Future<Map<String, dynamic>> setItem(
      String collection, Map<String, dynamic> data) async {
    var items = await getAll(collection);
    var newId = items.length + 1;
    data['id'] = '$newId';
    items.add(data);
    var instance = await SharedPreferences.getInstance();
    instance.setString(collection, jsonEncode(items));
    return data;
  }

  Future<Map<String, dynamic>?> createOrUpdateItem(
      String collection, Map<String, dynamic> data) async {
    if (data['id'] == null) {
      return setItem(collection, data);
    } else {
      var items = await getAll(collection);
      Map<String, dynamic>? changedItem;
      var newthings = items.map((e) {
        if (e['id'] == data['id']) {
          changedItem = data;
          return data;
        } else {
          return e;
        }
      }).toList();
      var instance = await SharedPreferences.getInstance();
      instance.setString(collection, jsonEncode(newthings));
      return changedItem;
    }
  }
}

class LocalDatabase extends Database {}
