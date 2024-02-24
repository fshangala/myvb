import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';

class VBGroupMemberModelArguments {
  String? id;
  String bankingGroupId;
  String userId;
  String email;
  bool approved;

  VBGroupMemberModelArguments(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.email,
      this.approved = false});
}

class VBGroupMember extends Model<VBGroupMember, VBGroupMemberModelArguments> {
  String? id;
  late String bankingGroupId;
  late String userId;
  late String email;
  late bool approved;

  @override
  String collection = 'bankingGroupMembers';

  @override
  VBGroupMember create(VBGroupMemberModelArguments arguments) {
    var vBGroupMember = VBGroupMember();
    vBGroupMember.id = arguments.id;
    vBGroupMember.bankingGroupId = arguments.bankingGroupId;
    vBGroupMember.userId = arguments.userId;
    vBGroupMember.email = arguments.email;
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
          email: data['email'],
          approved: data['approved']));
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bankingGroupId': bankingGroupId,
      'userId': userId,
      'email': email,
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
        .where('bankingGroupId', bankingGroupId)
        .where('userId', userId)
        .where('approved', true));
    for (var element in transactions) {
      balance += element.amount;
    }
    return balance;
  }

  requestLoan() async {
    //
  }

  Future<List<BankingGroupLoan>> getLoans() async {
    var loans = await BankingGroupLoan().getObjects(QueryBuilder()
        .where('bankingGroupId', bankingGroupId)
        .where('userId', userId));
    return loans;
  }

  Future<BankingGroupLoan?> getLatestLoan() async {
    BankingGroupLoan? latest;
    var loans = await BankingGroupLoan().getObjects(QueryBuilder()
        .where('bankingGroupId', bankingGroupId)
        .where('userId', userId)
        .where('referenceLoanId', null)
        .where('approved', true));
    for (var element in loans) {
      latest = element;
    }
    return latest;
  }

  Future<double> loanBalance() async {
    //get current balance
    double balance = 0.0;
    var loans = await BankingGroupLoan().getObjects(QueryBuilder()
        .where('bankingGroupId', bankingGroupId)
        .where('userId', userId)
        .where('approved', true));
    for (var element in loans) {
      balance += element.amount;
    }

    //charge penalty
    var latest = await getLatestLoan();
    var bankingGroup =
        await VBGroup().getObject(QueryBuilder().where('id', bankingGroupId));
    if (latest != null && balance > 0) {
      var today = DateTime.now();

      //for every loan period
      var duration = today.difference(latest.timestamp);
      if (duration.inDays > latest.period) {
        var penalty = balance *
            latest.loanInterest *
            0.01 *
            (duration.inDays / latest.period);
        await BankingGroupLoan()
            .create(BankingGroupLoanModelArguments(
                referenceLoanId: latest.id,
                bankingGroupId: bankingGroupId,
                userId: userId,
                email: email,
                amount: penalty,
                loanInterest: bankingGroup!.investmentInterest,
                period: bankingGroup.loanPeriod,
                issuedAt: latest.issuedAt,
                timestamp: DateTime.now(),
                approved: true))
            .save();
        latest.timestamp = today;
        await latest.save();

        return await loanBalance();
      }

      //for every investment cycle
      var issuedDuration = today.difference(latest.issuedAt);
      if (issuedDuration.inDays > bankingGroup!.investmentCycle) {
        var topay = 0.0;
        var myBalance = await investmentBalance();
        if (myBalance >= balance) {
          topay = balance;
        } else {
          topay = myBalance;
        }
        topay *= -1;
        await VBGroupTransaction()
            .create(VBGroupTransactionModelArguments(
                bankingGroupId: bankingGroupId,
                userId: userId,
                email: email,
                amount: topay,
                approved: true))
            .save();
        await BankingGroupLoan()
            .create(BankingGroupLoanModelArguments(
                referenceLoanId: latest.id,
                bankingGroupId: bankingGroupId,
                userId: userId,
                email: email,
                amount: topay,
                loanInterest: latest.loanInterest,
                period: latest.period,
                issuedAt: latest.issuedAt,
                timestamp: today))
            .save();

        return await loanBalance();
      }
    }

    return balance;
  }
}
