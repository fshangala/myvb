import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Database> databases = [
  LocalDatabase(),
];

abstract class Database {
  static Database getDatabase() {
    return databases[0];
  }

  Future<Map<String, dynamic>?> getItem(
      String collection, Map<String, dynamic> query) async {
    Map<String, dynamic>? item;
    var items = await getAll(collection);
    for (var element in items) {
      var matched = true;
      query.forEach((key, value) {
        if (element[key] != value) {
          matched = false;
        }
      });
      if (matched) {
        item = element;
        break;
      }
    }
    return item;
  }

  Future<List<Map<String, dynamic>>> getItems(
      String collection, Map<String, dynamic> query) async {
    List<Map<String, dynamic>> items = [];
    var allItems = await getAll(collection);
    if (query.isEmpty) {
      items = allItems;
    } else {
      for (var element in allItems) {
        var matched = true;
        query.forEach((key, value) {
          if (element[key] != value) {
            matched = false;
          }
        });
        if (matched) {
          items.add(element);
        }
      }
    }
    return items;
  }

  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    var instance = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results = [];
    var resultsData = instance.getString(collection);
    if (resultsData != null) {
      results = (jsonDecode(resultsData) as List).map((e) {
        Map<String, dynamic> a = e;
        return a;
      }).toList();
    }

    return results;
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

  Future<bool> clearDatabase() async {
    var instance = await SharedPreferences.getInstance();
    return await instance.clear();
  }
}

class LocalDatabase extends Database {}

class FirebaseDatabase extends Database {}
