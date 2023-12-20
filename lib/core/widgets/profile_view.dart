import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/show_loading.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  final User user;
  const UserProfile({super.key, required this.userId, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends AuthState<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Text('Username')),
            Text(user!.email!)
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text('Name')),
            Text(user!.displayName!)
          ],
        ),
        _ownerWidgets(user!),
      ],
    );
  }

  Column _ownerWidgets(User profile) {
    if (profile.uid == widget.user.uid) {
      return Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showLoading(context);
                AppUser().logout().then((value) {
                  Navigator.pop(context);
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
