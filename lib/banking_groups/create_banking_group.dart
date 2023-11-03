import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/banking_group_form.dart';
import 'package:myvb/users/login.dart';

class CreateBankingGroup extends StatefulWidget {
  const CreateBankingGroup({super.key});
  static String routeName = '/banking_group/create';

  @override
  State<StatefulWidget> createState() {
    return _CreateBankingGroupState();
  }
}

class _CreateBankingGroupState extends AuthState<CreateBankingGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Create Banking Group'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder(
              future: user,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return Column(
                      children: [
                        Center(
                          child: TextButton(
                              onPressed: () {
                                goTo(
                                    context: context,
                                    routeName: LoginScreen.routeName);
                              },
                              child: const Text('Please login')),
                        )
                      ],
                    );
                  }
                  return Column(
                    children: [
                      BankingGroupForm(
                        user: snapshot.data!,
                        onSaved: (bankingGroup) {
                          goTo(
                              context: context,
                              routeName: ViewBankingGroupScreen.routeName,
                              arguments: ArgumentsViewBankingGroup(
                                  id: bankingGroup.id!));
                        },
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
