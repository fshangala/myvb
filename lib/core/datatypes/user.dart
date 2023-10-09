import 'package:myvb/core/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  static const String collection = 'users';

  String? id;
  String username;
  String firstName;
  String lastName;
  String password;

  User(
      {this.id,
      required this.username,
      required this.firstName,
      required this.lastName,
      this.password = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id!,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'password': password
    };
  }

  static User fromMap(Map<String, dynamic> data) {
    return User(
        id: data['id'],
        username: data['username'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        password: data['password']);
  }

  static Future<User?> getByid(String id) async {
    var userData = await Database.getDatabase().getById(collection, id);
    if (userData == null) {
      return null;
    } else {
      return fromMap(userData);
    }
  }

  Future<void> save() {
    return Database.getDatabase().createOrUpdateItem('users', toMap());
  }

  static Future<User?> loggedInUser() async {
    var instance = await SharedPreferences.getInstance();
    var userId = instance.getString('loggedInUser');
    if (userId == null) {
      return null;
    } else {
      return User.getByid(userId);
    }
  }
}
