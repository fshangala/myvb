import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserFutureBuilder extends StatelessWidget {
  final Future<User?> user;
  final Widget Function(User user) futureRenderer;
  const UserFutureBuilder(
      {super.key, required this.user, required this.futureRenderer});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return futureRenderer(snapshot.data!);
            } else {
              return const Center(
                child: Text('Nothing to show'),
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }
}
