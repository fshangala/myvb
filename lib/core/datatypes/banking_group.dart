import 'package:myvb/core/database.dart';

class BankingGroup {
  String? id;
  String owner;
  String name;
  static String collection = 'banking_groups';

  BankingGroup({this.id, required this.owner, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'owner': owner, 'name': name};
  }

  static BankingGroup fromMap(Map<String, dynamic> data) {
    return BankingGroup(
        id: data['id'], owner: data['owner'], name: data['name']);
  }

  static Future<BankingGroup?> getById(String id) async {
    var bankingGroup = await Database.getDatabase().getById(collection, id);
    if (bankingGroup == null) {
      return null;
    } else {
      return fromMap(bankingGroup);
    }
  }

  static Future<List<BankingGroup>> getUserBankingGroups(String userId) async {
    List<BankingGroup> bankingGroups = [];
    var bankingGroupsData = await Database.getDatabase()
        .getItemsWhereEqual(collection, 'owner', userId);
    bankingGroups =
        bankingGroupsData.map((e) => BankingGroup.fromMap(e)).toList();
    return bankingGroups;
  }

  Future<BankingGroup?> save() async {
    var savedBankingGroup =
        await Database.getDatabase().createOrUpdateItem(collection, toMap());
    if (savedBankingGroup == null) {
      return null;
    } else {
      return BankingGroup.fromMap(savedBankingGroup);
    }
  }
}
