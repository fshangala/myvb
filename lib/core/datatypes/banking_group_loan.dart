import 'package:myvb/core/datatypes/model.dart';

class BankingGroupLoanModelArguments {
  String? id;
  String bankingGroupId;
  String userId;
  String username;
  double amount;
  DateTime timestamp;
  bool approved;

  BankingGroupLoanModelArguments(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.username,
      required this.amount,
      required this.timestamp,
      this.approved = false});
}

class BankingGroupLoan
    extends Model<BankingGroupLoan, BankingGroupLoanModelArguments> {
  String? id;
  late String bankingGroupId;
  late String userId;
  late String username;
  late double amount;
  late bool approved;

  @override
  String collection = 'bankingGroupLoans';

  @override
  BankingGroupLoan create(BankingGroupLoanModelArguments arguments) {
    var bankingGroupLoan = BankingGroupLoan();
    bankingGroupLoan.id = arguments.id;
    bankingGroupLoan.bankingGroupId = arguments.bankingGroupId;
    bankingGroupLoan.userId = arguments.userId;
    bankingGroupLoan.username = arguments.username;
    bankingGroupLoan.amount = arguments.amount;
    bankingGroupLoan.approved = arguments.approved;
    return bankingGroupLoan;
  }

  @override
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

  @override
  BankingGroupLoan? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(BankingGroupLoanModelArguments(
          id: data['id'],
          bankingGroupId: data['bankingGroupId'],
          userId: data['userId'],
          username: data['username'],
          amount: data['amount'],
          timestamp: data['timestamp'],
          approved: data['approved']));
    }
  }
}
