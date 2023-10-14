import 'package:myvb/core/database.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';

class BankingGroup {
  String? id;
  String owner;
  String name;
  List<BankingGroupMember> members;

  static String collection = 'banking_groups';

  BankingGroup(
      {this.id,
      required this.owner,
      required this.name,
      this.members = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'members': members.map((e) => e.toMap()).toList()
    };
  }

  static BankingGroup fromMap(Map<String, dynamic> data) {
    List<BankingGroupMember> groupMembers = [];
    if (data['members'].length > 0) {
      List<dynamic> a = data['members'];
      groupMembers = a.map((e) {
        Map<String, dynamic> b = e;
        return BankingGroupMember.fromMap(b);
      }).toList();
    }
    return BankingGroup(
        id: data['id'],
        owner: data['owner'],
        name: data['name'],
        members: groupMembers);
  }

  double totalInvestmentBalance() {
    double balance = 0.0;
    for (var member in members) {
      if (member.approved) {
        balance += member.investmentBalance;
      }
    }
    return balance;
  }

  static Future<List<BankingGroup>> getAll() async {
    var results = await Database.getDatabase().getAll(collection);
    var bankingGroups = results.map((e) => BankingGroup.fromMap(e)).toList();
    return bankingGroups;
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

  static Future<List<BankingGroup>> getUserJoinedBankingGroups(
      String username) async {
    var bankingGroups = await getAll();
    var joinedGroups = <BankingGroup>[];
    for (var element in bankingGroups) {
      for (var member in element.members) {
        if (member.username == username) {
          joinedGroups.add(element);
        }
      }
    }
    return bankingGroups;
  }

  static dynamic getMembers(
      {required String bankingGroupId, bool? approved}) async {
    var bankingGroup = await getById(bankingGroupId);
    if (bankingGroup == null) {
      return null;
    } else {
      var members = <BankingGroupMember>[];
      for (var element in bankingGroup.members) {
        if (approved == null) {
          members.add(element);
        } else {
          if (element.approved == approved) {
            members.add(element);
          }
        }
      }
      return members;
    }
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

  Future<BankingGroup?> joinGroup(
      String bankingGroupId, String userId, String username) async {
    var bankingGroup = await getById(bankingGroupId);
    if (bankingGroup != null) {
      bool alreadyJoined = false;
      for (var element in bankingGroup.members) {
        if (element.username == username) {
          alreadyJoined = true;
        }
      }
      if (alreadyJoined) {
        return null;
      } else {
        bankingGroup.members
            .add(BankingGroupMember(userId: userId, username: username));
        return await bankingGroup.save();
      }
    } else {
      return null;
    }
  }
}
