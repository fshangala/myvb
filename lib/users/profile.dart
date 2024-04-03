import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/home/home.dart';
import 'package:myvb/pages/transaction_tokens.dart';

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
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          minRadius: 50.0,
                          child: Image.asset(
                            "assets/My.png",
                            width: 70.0,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(luser.displayName!),
                                Text(luser.email!),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Text(
                        "Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        child: ListTile(
                          title: const Text("My Payments"),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            goTo(
                              context: context,
                              routeName: TransactionTokensPage.routeName,
                              permanent: false,
                            );
                          },
                          tileColor: Theme.of(context).colorScheme.background,
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  heightFactor: 2.0,
                  child: ElevatedButton(
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      resolveFuture(
                        context,
                        FirebaseAuth.instance.signOut(),
                        (value) {
                          goTo(
                              context: context,
                              routeName: HomeScreen.routeName);
                        },
                      );
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
