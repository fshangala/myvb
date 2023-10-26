import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/banking_group_members.dart';
import 'package:myvb/core/widgets/banking_group_transactions.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';
import 'package:myvb/users/login.dart';

class ViewBankingGroupScreen extends StatefulWidget {
  static const routeName = '/banking_group/view';
  const ViewBankingGroupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewBankingGroupState();
  }
}

class _ViewBankingGroupState extends State<ViewBankingGroupScreen> {
  late Future<User?> user;
  Future<BankingGroup?> bankingGroup = Future.value(null);
  Future<BankingGroupMember?> bankingGroupMember = Future.value(null);

  @override
  initState() {
    super.initState();
    user = User.loggedInUser();
    user.then((value) {
      if (value == null) {
        goTo(context: context, routeName: LoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsViewBankingGroup;
    bankingGroup = BankingGroup.getById(args.id);

    return Scaffold(
      appBar: appBar(context, 'View Banking Group'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            NullFutureRenderer(
                future: user,
                futureRenderer: (userObject) {
                  return NullFutureRenderer(
                      future: bankingGroup,
                      futureRenderer: (bankingGroupObject) {
                        bankingGroupMember =
                            bankingGroupObject.groupMember(userObject.id!);
                        return NullFutureRenderer(
                          future: bankingGroupMember,
                          futureRenderer: (bankingGroupMemberObject) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.tag),
                                  title: const Text('ID'),
                                  trailing: Text(bankingGroupObject.id!),
                                ),
                                ListTile(
                                  title: const Text('Name'),
                                  trailing: Text(bankingGroupObject.name),
                                ),
                                NotNullFutureRenderer(
                                    future: bankingGroupObject
                                        .totalInvestmentBalance(),
                                    futureRenderer: (totalAmount) {
                                      return ListTile(
                                        leading: const Icon(Icons.money),
                                        title: const Text('Investment Balance'),
                                        trailing: Text(totalAmount.toString()),
                                      );
                                    }),
                                BankingGroupMembers(
                                    bankingGroup: bankingGroupObject),
                                BankingGroupTransactions(
                                    bankingGroupId: bankingGroupObject.id!),
                              ],
                            );
                          },
                          nullRenderer: () {
                            return Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    var result = bankingGroupObject.joinGroup(
                                        userObject.id!, userObject.username);
                                    resolveFuture(context, result, (value) {
                                      setState(() {
                                        bankingGroupMember =
                                            Future.value(value);
                                      });
                                    });
                                  },
                                  child: const Text('Join Banking Group')),
                            );
                          },
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
