import 'package:myvb/core/database.dart';
import 'package:myvb/core/datatypes/model.dart';

class VBGroupTransactionModelArguments {
  String? id;
  String bankingGroupId;
  String userId;
  String username;
  double amount;
  bool approved;

  VBGroupTransactionModelArguments(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.username,
      required this.amount,
      this.approved = false});
}

class VBGroupTransaction
    extends Model<VBGroupTransaction, VBGroupTransactionModelArguments> {
  late String? id;
  late String bankingGroupId;
  late String userId;
  late String username;
  late double amount;
  late bool approved;

  @override
  String collection = 'bankingGroupTransactions';

  @override
  VBGroupTransaction create(VBGroupTransactionModelArguments arguments) {
    var vBGroupTransaction = VBGroupTransaction();
    vBGroupTransaction.id = arguments.id;
    vBGroupTransaction.bankingGroupId = arguments.bankingGroupId;
    vBGroupTransaction.userId = arguments.userId;
    vBGroupTransaction.username = arguments.username;
    vBGroupTransaction.amount = arguments.amount;
    vBGroupTransaction.approved = arguments.approved;
    return vBGroupTransaction;
  }

  @override
  VBGroupTransaction? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(VBGroupTransactionModelArguments(
          id: data['id'],
          bankingGroupId: data['bankingGroupId'],
          userId: data['userId'],
          username: data['username'],
          amount: data['amount'],
          approved: data['approved']));
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bankingGroupId': bankingGroupId,
      'userId': userId,
      'username': username,
      'amount': amount,
      'approved': approved
    };
  }
}

class BankingGroupTransaction {
  String? id;
  String bankingGroupId;
  String userId;
  String username;
  double amount;
  bool approved;

  static String collection = 'bankingGroupTransactions';

  BankingGroupTransaction(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.username,
      required this.amount,
      this.approved = false});

  Map<String, dynamic> toMap() {
    return {
      'di': id,
      'bankingGroupId': bankingGroupId,
      'userId': userId,
      'username': username,
      'amount': amount,
      'approved': approved
    };
  }

  static BankingGroupTransaction fromMap(Map<String, dynamic> data) {
    return BankingGroupTransaction(
        id: data['id'],
        bankingGroupId: data['bankingGroupId'],
        userId: data['userId'],
        username: data['username'],
        amount: data['amount'],
        approved: data['approved']);
  }

  static Future<BankingGroupTransaction?> getObject(
      QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItem(collection, queryBuilder.query);
    if (result == null) {
      return null;
    } else {
      return fromMap(result);
    }
  }

  static Future<List<BankingGroupTransaction>> getObjects(
      QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItems(collection, queryBuilder.query);
    return result.map((e) => fromMap(e)).toList();
  }

  static Future<List<BankingGroupTransaction>> getAll() async {
    var results = await Database.getDatabase().getAll(collection);
    var transactions =
        results.map((e) => BankingGroupTransaction.fromMap(e)).toList();
    return transactions;
  }

  static Future<List<BankingGroupTransaction>> getByBankingGroup(
      String bankingGroupId) async {
    var results = await Database.getDatabase()
        .getItemsWhereEqual(collection, 'bankingGroupId', bankingGroupId);
    var transactions =
        results.map((e) => BankingGroupTransaction.fromMap(e)).toList();
    return transactions;
  }

  Future<BankingGroupTransaction?> save() async {
    var savedTransaction =
        await Database.getDatabase().createOrUpdateItem(collection, toMap());
    if (savedTransaction == null) {
      return null;
    } else {
      return BankingGroupTransaction.fromMap(savedTransaction);
    }
  }
}
