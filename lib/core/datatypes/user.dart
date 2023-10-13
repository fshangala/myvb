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
      'id': id,
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

  static Future<User?> getUserWhere(String name, String value) async {
    var userData = await Database.getDatabase()
        .getItemWhereEqual('users', 'username', value);
    if (userData == null) {
      return null;
    } else {
      return User.fromMap(userData);
    }
  }

  Future<User?> save() async {
    var userWithUsername = await User.getUserWhere('username', username);
    if (id == null && userWithUsername != null) {
      return null;
    } else {
      var savedUser =
          await Database.getDatabase().createOrUpdateItem('users', toMap());
      if (savedUser != null) {
        return User.fromMap(savedUser);
      } else {
        return null;
      }
    }
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

  static Future<User?> login(String username, String password) async {
    User? luser;
    var user = await User.getUserWhere('username', username);
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
