import 'package:myvb/core/database.dart';
import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';

class VBGroupMemberModelArguments {
  String? id;
  String bankingGroupId;
  String userId;
  String username;
  bool approved;

  VBGroupMemberModelArguments(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.username,
      this.approved = false});
}

class VBGroupMember extends Model<VBGroupMember, VBGroupMemberModelArguments> {
  String? id;
  late String bankingGroupId;
  late String userId;
  late String username;
  late bool approved;

  @override
  String collection = 'bankingGroupMembers';

  @override
  VBGroupMember create(VBGroupMemberModelArguments arguments) {
    var vBGroupMember = VBGroupMember();
    vBGroupMember.id = arguments.id;
    vBGroupMember.bankingGroupId = arguments.bankingGroupId;
    vBGroupMember.userId = arguments.userId;
    vBGroupMember.username = arguments.username;
    vBGroupMember.approved = arguments.approved;
    return vBGroupMember;
  }

  @override
  VBGroupMember? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(VBGroupMemberModelArguments(
          id: data['id'],
          bankingGroupId: data['bankingGroupId'],
          userId: data['userId'],
          username: data['username'],
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
      'approved': approved
    };
  }

  Future<VBGroupMember?> approve() async {
    approved = true;
    return await save();
  }

  Future<double> investmentBalance() async {
    double balance = 0.0;
    var transactions = await VBGroupTransaction().getObjects(QueryBuilder()
        .where('bankingGroupId', id)
        .where('userId', userId)
        .where('approved', true));
    for (var element in transactions) {
      balance += element.amount;
    }
    return balance;
  }

  Future<double> loanBalance() async {
    double balance = 0.0;
    var loans = await BankingGroupLoan().getObjects(QueryBuilder()
        .where('bankingGroupId', bankingGroupId)
        .where('userId', userId)
        .where('approved', true));
    for (var element in loans) {
      balance += element.amount;
    }
    return balance;
  }
}

class BankingGroupMember {
  String? id;
  String bankingGroupId;
  String userId;
  String username;
  bool approved;

  static String collection = 'bankingGroupMembers';

  BankingGroupMember(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.username,
      this.approved = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bankingGroupId': bankingGroupId,
      'userId': userId,
      'username': username,
      'approved': approved
    };
  }

  static BankingGroupMember fromMap(Map<String, dynamic> data) {
    return BankingGroupMember(
        id: data['id'],
        bankingGroupId: data['bankingGroupId'],
        userId: data['userId'],
        username: data['username'],
        approved: data['approved']);
  }

  Future<BankingGroupMember?> save() async {
    var result =
        await Database.getDatabase().createOrUpdateItem(collection, toMap());
    if (result == null) {
      return null;
    } else {
      return BankingGroupMember.fromMap(result);
    }
  }

  Future<BankingGroupMember?> approve() async {
    approved = true;
    return await save();
  }

  Future<double> investmentBalance() async {
    double balance = 0.0;
    var transactions = await BankingGroupTransaction.getObjects(QueryBuilder()
        .where('bankingGroupId', id)
        .where('userId', userId)
        .where('approved', true));
    for (var element in transactions) {
      balance += element.amount;
    }
    return balance;
  }

  static Future<BankingGroupMember?> getObject(
      QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItem(collection, queryBuilder.query);
    if (result == null) {
      return null;
    } else {
      return fromMap(result);
    }
  }

  static Future<List<BankingGroupMember>> getObjects(
      QueryBuilder queryBuilder) async {
    var result =
        await Database.getDatabase().getItems(collection, queryBuilder.query);
    return result.map((e) => fromMap(e)).toList();
  }
}
