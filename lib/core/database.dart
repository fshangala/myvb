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

  Future<void> setItem(String collection, Map<String, dynamic> data) async {
    var items = await getAll(collection);
    data['id'] = items.length + 1;
    items.add(data);
    var instance = await SharedPreferences.getInstance();
    instance.setString(collection, jsonEncode(items));
  }

  Future<void> createOrUpdateItem(
      String collection, Map<String, dynamic> data) async {
    if (data['id'] == null) {
      await setItem(collection, data);
    } else {
      var items = await getAll(collection);
      var newthings = items.map((e) {
        if (e['id'] == data['id']) {
          return data;
        } else {
          return e;
        }
      }).toList();
      var instance = await SharedPreferences.getInstance();
      instance.setString(collection, jsonEncode(newthings));
    }
  }
}

class LocalDatabase extends Database {}
