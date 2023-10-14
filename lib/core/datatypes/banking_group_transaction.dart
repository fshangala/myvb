import 'package:myvb/core/database.dart';

class BankingGroupTransaction {
  String? id;
  String bankingGroupId;
  String username;
  double amount;
  bool approved;

  static const collection = 'bankingGroupTransactions';

  BankingGroupTransaction(
      {this.id,
      required this.bankingGroupId,
      required this.username,
      required this.amount,
      this.approved = false});

  Map<String, dynamic> toMap() {
    return {
      'di': id,
      'bankingGroupId': bankingGroupId,
      'username': username,
      'amount': amount,
      'approved': approved
    };
  }

  static BankingGroupTransaction fromMap(Map<String, dynamic> data) {
    return BankingGroupTransaction(
        id: data['id'],
        bankingGroupId: data['bankingGroupId'],
        username: data['username'],
        amount: data['amount'],
        approved: data['approved']);
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
