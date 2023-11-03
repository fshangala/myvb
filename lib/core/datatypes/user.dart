import 'package:shared_preferences/shared_preferences.dart';
import 'package:myvb/core/datatypes/model.dart';

class UserModelArguments {
  String? id;
  String username;
  String firstName;
  String lastName;
  String password;

  UserModelArguments(
      {this.id,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.password});
}

class User extends Model<User, UserModelArguments> {
  String? id;
  late String username;
  late String firstName;
  late String lastName;
  late String password;

  @override
  String collection = 'bankingGroupTransactions';

  @override
  User create(UserModelArguments arguments) {
    var user = User();
    user.id = arguments.id;
    user.username = arguments.username;
    user.firstName = arguments.firstName;
    user.lastName = arguments.lastName;
    user.password = arguments.password;
    return user;
  }

  @override
  User? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(UserModelArguments(
          id: data['id'],
          username: data['username'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          password: data['password']));
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'password': password
    };
  }

  Future<User?> loggedInUser() async {
    var instance = await SharedPreferences.getInstance();
    var userId = instance.getString('loggedInUser');
    if (userId == null) {
      return null;
    } else {
      return User().getObject(QueryBuilder().where('id', userId));
    }
  }

  Future<User?> login(String username, String password) async {
    User? luser;
    var user =
        await User().getObject(QueryBuilder().where('username', username));
    if (user != null && user.password == password) {
      luser = user;
      var instance = await SharedPreferences.getInstance();
      instance.setString('loggedInUser', user.id!);
    }
    return luser;
  }

  Future<bool> logout() async {
    var instance = await SharedPreferences.getInstance();
    return await instance.remove('loggedInUser');
  }
}
