import 'package:myvb/core/datatypes/model.dart';

class VBGroupTransactionModelArguments {
  String? id;
  String bankingGroupId;
  String userId;
  String email;
  double amount;
  bool approved;

  VBGroupTransactionModelArguments(
      {this.id,
      required this.bankingGroupId,
      required this.userId,
      required this.email,
      required this.amount,
      this.approved = false});
}

class VBGroupTransaction
    extends Model<VBGroupTransaction, VBGroupTransactionModelArguments> {
  late String? id;
  late String bankingGroupId;
  late String userId;
  late String email;
  late double amount;
  late bool approved;

  @override
  String collection = 'bankingGroupTransactions';

  @override
  VBGroupTransaction create(VBGroupTransactionModelArguments arguments) {
    var vBGroupTransaction = VBGroupTransaction();
    vBGroupTransaction.id = arguments.id;
    vBGroupTransaction.bankingGroupId = arguments.bankingGroupId;
    vBGroupTransaction.userId = arguments.userId;
    vBGroupTransaction.email = arguments.email;
    vBGroupTransaction.amount = arguments.amount;
    vBGroupTransaction.approved = arguments.approved;
    return vBGroupTransaction;
  }

  @override
  VBGroupTransaction? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(VBGroupTransactionModelArguments(
          id: data['id'],
          bankingGroupId: data['bankingGroupId'],
          userId: data['userId'],
          email: data['email'],
          amount: double.parse(data['amount'].toString()),
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
      'amount': amount,
      'approved': approved
    };
  }
}
