import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/show_loading.dart';
import 'package:myvb/users/login.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  final User user;
  const UserProfile({super.key, required this.userId, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {
  late Future<User?> profile;

  @override
  void initState() {
    super.initState();
    profile = User().getObject(QueryBuilder().where('id', widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: profile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Username')),
                          Text(snapshot.data!.username)
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text('First name')),
                          Text(snapshot.data!.firstName)
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text('Last name')),
                          Text(snapshot.data!.lastName)
                        ],
                      ),
                      _ownerWidgets(snapshot.data!),
                    ],
                  );
                } else {
                  return const Text('Profile not found!');
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }

  Column _ownerWidgets(User profile) {
    if (profile.id == widget.user.id) {
      return Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showLoading(context);
                widget.user.logout().then((value) {
                  Navigator.pop(context);
                  if (value) {
                    displayRegularSnackBar(context, 'You are logged out!');
                    goTo(context: context, routeName: LoginScreen.routeName);
                  } else {
                    displayRegularSnackBar(context, 'Could not logout!');
                  }
                }).onError((error, stackTrace) {
                  Navigator.pop(context);
                  displayRegularSnackBar(context, 'Error: $error');
                });
              },
              child: const Text('Logout'))
        ],
      );
    } else {
      return const Column();
    }
  }
}
