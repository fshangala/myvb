import 'package:myvb/core/datatypes/model.dart';

class TransactionTokenModelArguments {
  String? id;
  String bankingGroupId;
  String userId;
  String email;
  String token;
  double amount;
  DateTime issuedAt;
  DateTime timestamp;
  bool paid;

  TransactionTokenModelArguments({
    this.id,
    required this.bankingGroupId,
    required this.userId,
    required this.email,
    required this.token,
    required this.amount,
    required this.issuedAt,
    required this.timestamp,
    this.paid = false,
  });
}

class TransactionToken
    extends Model<TransactionToken, TransactionTokenModelArguments> {
  String? id;
  late String bankingGroupId;
  late String userId;
  late String email;
  late String token;
  late double amount;
  late DateTime issuedAt;
  late DateTime timestamp;
  late bool paid;

  @override
  String collection = "transactionToken";

  @override
  TransactionToken create(TransactionTokenModelArguments arguments) {
    var token = TransactionToken();
    token.id = arguments.id;
    token.bankingGroupId = arguments.bankingGroupId;
    token.userId = arguments.userId;
    token.email = arguments.email;
    token.token = arguments.token;
    token.amount = arguments.amount;
    token.issuedAt = arguments.issuedAt;
    token.timestamp = arguments.timestamp;
    token.paid = arguments.paid;
    return token;
  }

  @override
  TransactionToken? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(
        TransactionTokenModelArguments(
          id: data["id"],
          bankingGroupId: data["bankingGroupId"],
          userId: data["userId"],
          email: data["email"],
          token: data["token"],
          amount: data["amount"],
          issuedAt: DateTime.parse(data['issuedAt']),
          timestamp: DateTime.parse(data['timestamp']),
          paid: data["paid"],
        ),
      );
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "bankingGroupId": bankingGroupId,
      "userId": userId,
      "email": email,
      "token": token,
      "amount": amount,
      "issuedAt": issuedAt.toString(),
      "timestamp": timestamp.toString(),
      "paid": paid,
    };
  }
}
