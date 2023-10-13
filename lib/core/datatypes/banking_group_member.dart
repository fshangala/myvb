class BankingGroupMember {
  String userId;
  String username;
  BankingGroupMember({required this.userId, required this.username});

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'username': username};
  }

  static BankingGroupMember fromMap(Map<String, dynamic> data) {
    return BankingGroupMember(
        userId: data['userId'], username: data['username']);
  }
}
