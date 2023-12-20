import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myvb/core/datatypes/model.dart';

class UserModelArguments {
  String? id;
  String email;
  String firstName;
  String lastName;
  String password;

  UserModelArguments(
      {this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.password});
}

class AppUser extends Model<AppUser, UserModelArguments> {
  User? user;

  @override
  String collection = 'users';

  @override
  AppUser create(UserModelArguments arguments) {
    return AppUser();
  }

  @override
  AppUser? fromMap(Map<String, dynamic>? data) {
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }

  Future<AppUser?> loggedInUser() async {
    var instance = await SharedPreferences.getInstance();
    var userId = instance.getString('loggedInUser');
    if (userId == null) {
      return null;
    } else {
      return AppUser().getObject(QueryBuilder().where('id', userId));
    }
  }

  Future<User?> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    user = credential.user;

    //var instance = await SharedPreferences.getInstance();
    //instance.setString('loggedInUser', user!.uid);

    return user;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
