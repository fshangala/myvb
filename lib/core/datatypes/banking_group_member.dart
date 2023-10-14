class BankingGroupMember {
  String userId;
  String username;
  double investmentBalance;
  bool approved;

  BankingGroupMember(
      {required this.userId,
      required this.username,
      this.investmentBalance = 0.0,
      this.approved = false});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'investmentBalance': investmentBalance
    };
  }

  static BankingGroupMember fromMap(Map<String, dynamic> data) {
    return BankingGroupMember(
        userId: data['userId'],
        username: data['username'],
        investmentBalance: data['investmentBalance']);
  }
}
