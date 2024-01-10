import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Database> databases = [
  FirebaseDatabase(),
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

class FirebaseDatabase extends Database {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> setItem(
      String collection, Map<String, dynamic> data) async {
    var doc = await db.collection(collection).add(data);
    var response = await doc.get();
    return response.data()!;
  }

  @override
  Future<List<Map<String, dynamic>>> getItems(
      String collection, Map<String, dynamic> query) async {
    if (query.isEmpty) {
      var items = await db.collection(collection).get();
      return items.docs.map((e) => e.data()).toList();
    } else {
      Query<Map<String, dynamic>> firequery = db.collection(collection);
      query.forEach((key, value) {
        firequery = firequery.where(key, isEqualTo: value);
      });
      var items = await firequery.get();
      return items.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<Map<String, dynamic>?> getItem(
      String collection, Map<String, dynamic> query) async {
    if (query.containsKey('id')) {
      var item = await db.collection(collection).doc(query['id']).get();
      return item.data();
    }

    if (query.isEmpty) {
      return null;
    } else {
      Query<Map<String, dynamic>> firequery = db.collection(collection);
      query.forEach((key, value) {
        firequery = firequery.where(key, isEqualTo: value);
      });
      var items = await firequery.get();
      return items.docs[0].data();
    }
  }

  @override
  Future<Map<String, dynamic>?> createOrUpdateItem(
      String collection, Map<String, dynamic> data) async {
    if (data.containsKey('id')) {
      var doc = db.collection(collection).doc(data['id']);
      await doc.update(data);
      return await getItem(collection, data);
    } else {
      return setItem(collection, data);
    }
  }
}
