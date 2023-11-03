import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/profile_screen_arguments.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/profile_view.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends AuthState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsProfileScreen?;
    return Scaffold(
      appBar: appBar(context, 'Profile'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FutureBuilder(
                future: user,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return _userProfile(args: args, user: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }

  UserProfile _userProfile({ArgumentsProfileScreen? args, required User user}) {
    if (args == null) {
      return UserProfile(userId: user.id!, user: user);
    } else {
      return UserProfile(userId: args.userId, user: user);
    }
  }
}
