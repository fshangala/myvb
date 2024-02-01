import 'package:myvb/core/datatypes/model.dart';

class BankingGroupLoanModelArguments {
  String? id;
  String? referenceLoanId;
  String bankingGroupId;
  String userId;
  String email;
  double amount;
  double loanInterest;
  int period;
  DateTime issuedAt;
  DateTime timestamp;
  bool approved;

  BankingGroupLoanModelArguments(
      {this.id,
      this.referenceLoanId,
      required this.bankingGroupId,
      required this.userId,
      required this.email,
      required this.amount,
      required this.loanInterest,
      required this.period,
      required this.issuedAt,
      required this.timestamp,
      this.approved = false});
}

class BankingGroupLoan
    extends Model<BankingGroupLoan, BankingGroupLoanModelArguments> {
  String? id;
  String? referenceLoanId;
  late String bankingGroupId;
  late String userId;
  late String email;
  late double amount;
  late double loanInterest;
  late int period;
  late DateTime issuedAt;
  late DateTime timestamp;
  late bool approved;

  @override
  String collection = 'bankingGroupLoans';

  @override
  BankingGroupLoan create(BankingGroupLoanModelArguments arguments) {
    var bankingGroupLoan = BankingGroupLoan();
    bankingGroupLoan.id = arguments.id;
    bankingGroupLoan.referenceLoanId = arguments.referenceLoanId;
    bankingGroupLoan.bankingGroupId = arguments.bankingGroupId;
    bankingGroupLoan.userId = arguments.userId;
    bankingGroupLoan.email = arguments.email;
    bankingGroupLoan.amount = arguments.amount;
    bankingGroupLoan.loanInterest = arguments.loanInterest;
    bankingGroupLoan.period = arguments.period;
    bankingGroupLoan.issuedAt = arguments.issuedAt;
    bankingGroupLoan.timestamp = arguments.timestamp;
    bankingGroupLoan.approved = arguments.approved;
    return bankingGroupLoan;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referenceLoanId': referenceLoanId,
      'bankingGroupId': bankingGroupId,
      'userId': userId,
      'email': email,
      'amount': amount,
      'loanInterest': loanInterest,
      'period': period,
      'issuedAt': issuedAt.toString(),
      'timestamp': timestamp.toString(),
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
          referenceLoanId: data['referenceLoanId'],
          bankingGroupId: data['bankingGroupId'],
          userId: data['userId'],
          email: data['email'],
          amount: data['amount'],
          loanInterest: data['loanInterest'],
          period: data['period'],
          issuedAt: DateTime.parse(data['issuedAt']),
          timestamp: DateTime.parse(data['timestamp']),
          approved: data['approved']));
    }
  }
}
