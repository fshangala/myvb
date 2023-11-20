import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';

class VBGroupModelArguments {
  String? id;
  String owner;
  String name;
  double investmentInterest;
  int loanPeriod;
  int investmentCycle;

  VBGroupModelArguments(
      {this.id,
      required this.owner,
      required this.name,
      required this.investmentInterest,
      required this.loanPeriod,
      required this.investmentCycle});
}

class VBGroup extends Model<VBGroup, VBGroupModelArguments> {
  String? id;
  late String owner;
  late String name;
  late double investmentInterest;
  late int loanPeriod;
  late int investmentCycle;

  @override
  String collection = 'banking_groups';

  @override
  VBGroup create(VBGroupModelArguments arguments) {
    var vBGroup = VBGroup();
    vBGroup.id = arguments.id;
    vBGroup.owner = arguments.owner;
    vBGroup.name = arguments.name;
    vBGroup.investmentInterest = arguments.investmentInterest;
    vBGroup.loanPeriod = arguments.loanPeriod;
    vBGroup.investmentCycle = arguments.investmentCycle;
    return vBGroup;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'investmentInterest': investmentInterest,
      'loanPeriod': loanPeriod,
      'investmentCycle': investmentCycle
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
          investmentInterest: data['investmentInterest'],
          loanPeriod: data['loanPeriod'],
          investmentCycle: data['investmentCycle']));
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

  Future<List<VBGroup>> joinedGroups(String userId) async {
    var groups = <VBGroup>[];
    var allGroups = await VBGroup().getObjects(QueryBuilder());
    for (var group in allGroups) {
      var groupMembers = await group.groupMembers(null);
      for (var member in groupMembers) {
        if (member.userId == userId) {
          groups.add(group);
        }
      }
    }
    return groups;
  }
}
