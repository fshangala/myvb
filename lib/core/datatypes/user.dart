import 'package:firebase_auth/firebase_auth.dart';
import 'package:myvb/core/datatypes/model.dart';

class UserModelArguments {
  String? id;
  String uid;
  String email;
  String firstName;
  String lastName;
  String role;

  UserModelArguments({
    this.id,
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.role = "user",
  });
}

class AppUser extends Model<AppUser, UserModelArguments> {
  String? id;
  late String uid;
  late String email;
  late String firstName;
  late String lastName;
  late String role;

  @override
  String collection = 'users';

  @override
  AppUser create(UserModelArguments arguments) {
    var user = AppUser();
    user.id = arguments.id;
    user.uid = arguments.uid;
    user.email = arguments.email;
    user.firstName = arguments.firstName;
    user.lastName = arguments.lastName;
    user.role = arguments.role;
    return user;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }

  @override
  AppUser? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    } else {
      return create(UserModelArguments(
        uid: data['uid'],
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        role: data['role'],
      ));
    }
  }

  Future<User?> registerUser(
      {required String email,
      required String firstName,
      required String lastName,
      required String password}) async {
    var userCredentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredentials.user?.updateDisplayName('$firstName $lastName');
    var appUser = create(UserModelArguments(
        uid: userCredentials.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName));
    await appUser.save();
    return userCredentials.user!;
  }

  Future<User?> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
