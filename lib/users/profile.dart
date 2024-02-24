import 'package:flutter/material.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState2();
  }
}

class _ProfileScreenState2 extends AuthState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //var args = ModalRoute.of(context)!.settings.arguments as ArgumentsProfileScreen?;
    return userWidget((luser) => Scaffold(
          appBar: appBar(context, '${luser.email}'),
          body: RefreshIndicator(
            child: ListView(
              children: [
                const Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        minRadius: 50.0,
                        child: Icon(
                          Icons.person,
                          size: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(luser.email!),
                ),
                Center(
                  heightFactor: 2.0,
                  child: ElevatedButton(
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      //TODO: Logout a user
                    },
                  ),
                ),
              ],
            ),
            onRefresh: () async {
              //TODO: Refresh profile page
            },
          ),
        ));
  }
}
