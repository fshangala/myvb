import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group_member.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/datatypes/view_group_member_arguments.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/banking_group_members.dart';
import 'package:myvb/core/widgets/banking_group_transactions.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class ViewBankingGroupScreen extends StatefulWidget {
  static const routeName = '/banking_group/view';
  const ViewBankingGroupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewBankingGroupState();
  }
}

class _ViewBankingGroupState extends AuthState<ViewBankingGroupScreen> {
  Future<VBGroup?> bankingGroup = Future.value(null);
  Future<VBGroupMember?> bankingGroupMember = Future.value(null);
  Future<VBGroup?> bankingGroupFuture = Future.value(null);

  VBGroup vbgroupAPI = VBGroup();

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsViewBankingGroup;
    bankingGroup = vbgroupAPI.getObject(QueryBuilder().where('id', args.id));

    return AppScaffold(
        title: 'View Banking Group',
        onRefresh: () {},
        children: [
          userWidget((luser) => NullFutureRenderer(
              future: bankingGroup,
              futureRenderer: (bankingGroupObject) {
                bankingGroupMember = bankingGroupObject.groupMember(luser.uid);
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.tag),
                      title: const Text('ID'),
                      trailing: Text(bankingGroupObject.id!),
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: bankingGroupObject.id!))
                            .then((value) {
                          displayRegularSnackBar(
                              context, 'ID copied to clipboard!');
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Name'),
                      trailing: Text(bankingGroupObject.name),
                    ),
                    NotNullFutureRenderer(
                        future: bankingGroupObject.totalIvenstmentBalance(),
                        futureRenderer: (totalAmount) {
                          return ListTile(
                            leading: const Icon(Icons.money),
                            title: const Text('Investment Balance'),
                            trailing: Text(totalAmount.toString()),
                          );
                        }),
                    const Divider(),
                    BankingGroupMembers(bankingGroup: bankingGroupObject),
                    BankingGroupTransactions(
                        bankingGroupId: bankingGroupObject.id!),
                    NullFutureRenderer(
                        future: bankingGroupMember,
                        futureRenderer: (bankingGroupMemberObject) {
                          return NotNullFutureRenderer(
                              future:
                                  bankingGroupMemberObject.investmentBalance(),
                              futureRenderer: (myBalance) {
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(bankingGroupMemberObject.email),
                                  subtitle:
                                      const Text('Manage your investments'),
                                  trailing: Text(myBalance.toString()),
                                  onTap: () {
                                    goTo(
                                        context: context,
                                        routeName: ViewBankingGroupMemberScreen
                                            .routeName,
                                        arguments: ArgumentsViewGroupMember(
                                            bankingGroupObject.id!,
                                            bankingGroupMemberObject.id!),
                                        permanent: false);
                                  },
                                );
                              });
                        })
                  ],
                );
              })),
        ]);

    /*return Scaffold(
      appBar: appBar(context, 'View Banking Group'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            NullFutureRenderer(
              future: bankingGroup,
              futureRenderer: (bankingGroupObject) {
                bankingGroupMember = bankingGroupObject.groupMember(user!.uid);
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
                            future: bankingGroupObject.totalIvenstmentBalance(),
                            futureRenderer: (totalAmount) {
                              log(totalAmount.toString(),name: 'TotalAmount');
                              return ListTile(
                                leading: const Icon(Icons.money),
                                title: const Text('Investment Balance'),
                                trailing: Text(totalAmount.toString()),
                              );
                            }),
                        const Divider(),
                        NotNullFutureRenderer(
                            future:
                                bankingGroupMemberObject.investmentBalance(),
                            futureRenderer: (myBalance) {
                              log(myBalance.toString(),name: 'MyBalance');
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(bankingGroupMemberObject.email),
                                subtitle: const Text('Manage your investments'),
                                trailing: Text(myBalance.toString()),
                                onTap: () {
                                  goTo(
                                      context: context,
                                      routeName: ViewBankingGroupMemberScreen
                                          .routeName,
                                      arguments: ArgumentsViewGroupMember(
                                          bankingGroupObject.id!,
                                          bankingGroupMemberObject.id!),
                                      permanent: false);
                                },
                              );
                            }),
                        BankingGroupMembers(bankingGroup: bankingGroupObject),
                        BankingGroupTransactions(
                            bankingGroupId: bankingGroupObject.id!),
                      ],
                    );
                  },
                  nullRenderer: () {
                    return Center(
                      child: ElevatedButton(
                          onPressed: () {
                            var result = bankingGroupObject.joinGroup(user!);
                            resolveFuture(context, result, (value) {
                              setState(() {
                                bankingGroupMember = Future.value(value);
                              });
                            });
                          },
                          child: const Text('Join Banking Group')),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );*/
  }
}
