import 'package:myvb/core/database.dart';

class BankingGroup {
  String owner;
  String name;
  static String collection = 'banking_groups';

  BankingGroup({required this.owner, required this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  static BankingGroup fromMap(Map<String, dynamic> data) {
    return BankingGroup(owner: data['owner'], name: data['name']);
  }

  static Future<List<BankingGroup>> getUserBankingGroups(String userId) async {
    List<BankingGroup> bankingGroups = [];
    var bankingGroupsData = await Database.getDatabase()
        .getItemsWhereEqual(collection, 'owner', userId);
    bankingGroups =
        bankingGroupsData.map((e) => BankingGroup.fromMap(e)).toList();
    return bankingGroups;
  }

  Future<void> save(String userId) async {
    return Database.getDatabase().createOrUpdateItem(collection, toMap());
  }
}
