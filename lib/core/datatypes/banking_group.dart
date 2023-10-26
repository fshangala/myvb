import 'package:myvb/core/database.dart';
import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';

class VBGroupModelArguments {
  String? id;
  String owner;
  String name;
  int investmentInterest;

  VBGroupModelArguments(
      {this.id,
      required this.owner,
      required this.name,
      required this.investmentInterest});
}

class VBGroup extends Model<VBGroup, VBGroupModelArguments> {
  String? id;
  late String owner;
  late String name;
  late int investmentInterest;

  @override
  String collection = 'bankingGroups';

  @override
  VBGroup create(VBGroupModelArguments arguments) {
    var vBGroup = VBGroup();
    vBGroup.id = arguments.id;
    vBGroup.owner = arguments.owner;
    vBGroup.name = arguments.name;
    vBGroup.investmentInterest = arguments.investmentInterest;
    return vBGroup;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'investmentInterest': investmentInterest
    };
  }

  @override
  VBGroup? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(VBGroupModelArguments(
          id: data['id'],
          owner: data['owner'],
          name: data['name'],
          investmentInterest: data['investmentInterest']));
    }
  }

  Future<double> totalIvenstmentBalance() async {
    var balance = 0.0;

    //transactions
    var transactions = await VBGroupTransaction().getObjects(
        QueryBuilder().where('bankingGroupId', id).where('approved', true));
    for (var element in transactions) {
      balance += element.amount;
    }

    //loans
    var loans = await BankingGroupLoan().getObjects(
        QueryBuilder().where('bankingGroupId', id!).where('approved', true));
    for (var element in loans) {
      balance -= element.amount;
    }

    return balance;
  }

  Future<VBGroupMember?> groupMember(String userId) async {
    var member = await VBGroupMember().getObject(
        QueryBuilder().where('bankingGroupId', id).where('userId', userId));
    return member;
  }

  Future<List<VBGroupMember>> groupMembers(bool? approved) async {
    List<VBGroupMember> members = [];
    if (approved == null) {
      members = await VBGroupMember()
          .getObjects(QueryBuilder().where('bankingGroupId', id));
    } else {
      members = await VBGroupMember().getObjects(QueryBuilder()
          .where('bankingGroupId', id)
          .where('approved', approved));
    }
    return members;
  }

  Future<VBGroupMember?> joinGroup(String userId, String username) async {
    var bankingGroupMember = await VBGroupMember().getObject(
        QueryBuilder().where('userId', userId).where('bankingGroupId', id));
    if (bankingGroupMember == null) {
      bankingGroupMember = VBGroupMember().create(VBGroupMemberModelArguments(
          bankingGroupId: id!, userId: userId, username: username));
      var saved = await bankingGroupMember.save();
      if (saved == null) {
        return null;
      } else {
        return saved;
      }
    } else {
      return null;
    }
  }
}

///Create banking group objects
class BankingGroup {
  String? id;
  String owner;
  String name;

  static String collection = 'banking_groups';

  BankingGroup({this.id, required this.owner, required this.name});

  Future<double> totalInvestmentBalance() async {
    double balance = 0.0;
    var transactions = await BankingGroupTransaction.getObjects(
        QueryBuilder().where('bankingGroupId', id).where('approved', true));
    for (var element in transactions) {
      balance += element.amount;
    }
    return balance;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'owner': owner, 'name': name};
  }

  static BankingGroup fromMap(Map<String, dynamic> data) {
    return BankingGroup(
        id: data['id'], owner: data['owner'], name: data['name']);
  }

  static Future<BankingGroup?> getObject(QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItem(collection, queryBuilder.query);
    if (result == null) {
      return null;
    } else {
      return fromMap(result);
    }
  }

  static Future<List<BankingGroup>> getObjects(
      QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItems(collection, queryBuilder.query);
    return result.map((e) => fromMap(e)).toList();
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
    var joinedGroups = <BankingGroup>[];
    return joinedGroups;
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

  Future<BankingGroupMember?> groupMember(String userId) async {
    var member = await BankingGroupMember.getObject(
        QueryBuilder().where('bankingGroupId', id).where('userId', userId));
    return member;
  }

  Future<List<BankingGroupMember>> groupMembers(bool? approved) async {
    List<BankingGroupMember> members = [];
    if (approved == null) {
      members = await BankingGroupMember.getObjects(
          QueryBuilder().where('bankingGroupId', id));
    } else {
      members = await BankingGroupMember.getObjects(QueryBuilder()
          .where('bankingGroupId', id)
          .where('approved', approved));
    }
    return members;
  }

  Future<BankingGroupMember?> joinGroup(String userId, String username) async {
    var bankingGroupMember = await BankingGroupMember.getObject(
        QueryBuilder().where('userId', userId).where('bankingGroupId', id));
    if (bankingGroupMember == null) {
      bankingGroupMember = BankingGroupMember(
          bankingGroupId: id!, userId: userId, username: username);
      var saved = await bankingGroupMember.save();
      if (saved == null) {
        return null;
      } else {
        return saved;
      }
    } else {
      return null;
    }
  }
}
