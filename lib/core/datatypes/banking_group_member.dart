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
    BankingGroupLoan? latest;
    double balance = 0.0;
    var loans = await BankingGroupLoan().getObjects(QueryBuilder()
        .where('bankingGroupId', bankingGroupId)
        .where('userId', userId)
        .where('approved', true));
    for (var element in loans) {
      if (element.amount > 0) {
        latest = element;
      }
      balance += element.amount;
    }
    if (latest != null && balance > 0) {
      var today = DateTime.now();
      var duration = today.difference(latest.timestamp);
      if (duration.inDays > 30) {
        var penalty = balance * 10 * 0.01;
        await BankingGroupLoan()
            .create(BankingGroupLoanModelArguments(
                bankingGroupId: bankingGroupId,
                userId: userId,
                username: username,
                amount: penalty,
                timestamp: DateTime.now(),
                approved: true))
            .save();
        return await loanBalance();
      }
    }
    return balance;
  }
}
