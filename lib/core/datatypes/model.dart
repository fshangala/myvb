import 'package:myvb/core/database.dart';

enum Join { and, or }

class QueryBuilder {
  Map<String, dynamic> query = {};
  QueryBuilder where(String key, value, {Join join = Join.and}) {
    query[key] = value;
    return this;
  }
}

abstract class Model<T, A> {
  abstract String collection;

  T create(A arguments);

  Map<String, dynamic> toMap();

  T? fromMap(Map<String, dynamic>? data);

  Future<T?> getObject(QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItem(collection, queryBuilder.query);
    return fromMap(result);
  }

  Future<List<T>> getObjects(QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItems(collection, queryBuilder.query);
    return result.map((e) => fromMap(e)!).toList();
  }

  Future<T?> save() async {
    var savedTransaction =
        await Database.getDatabase().createOrUpdateItem(collection, toMap());
    return fromMap(savedTransaction);
  }
}
