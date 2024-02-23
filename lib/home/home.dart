import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _HomeState2();
  }
}

class _HomeState2 extends AuthState<HomeScreen> {
  var vbGroup = VBGroup();
  var vbGroupMember = VBGroupMember();
  Future<List<VBGroup>> userBankingGroupsFuture = Future.value(<VBGroup>[]);

  Future<List<VBGroup>> userBankingGroups(String userId) async {
    List<VBGroupMember> members =
        await vbGroupMember.getObjects(QueryBuilder().where('userId', userId));
    var groups = <VBGroup>[];
    for (var element in members) {
      var group = await vbGroup
          .getObject(QueryBuilder().where('id', element.bankingGroupId));
      if (group != null) {
        groups.add(group);
      }
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return userWidget((luser) {
      userBankingGroupsFuture = userBankingGroups(luser.uid);
      return Scaffold(
        appBar: appBar(context, 'Home'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, CreateBankingGroup.routeName);
          },
          tooltip: 'Create Banking Group',
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              userBankingGroupsFuture = userBankingGroups(luser.uid);
            });
          },
          child: ListView(
            children: [
              Column(
                children: [
                  NotNullFutureRenderer(
                      future: userBankingGroupsFuture,
                      futureRenderer: (bankingGroups) {
                        return BankingGroups(bankingGroups: bankingGroups);
                      }),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class BankingGroups extends StatelessWidget {
  final List<VBGroup> bankingGroups;
  const BankingGroups({super.key, required this.bankingGroups});

  @override
  Widget build(BuildContext context) {
    if (bankingGroups.isEmpty) {
      return const Text('No banking groups.');
    }
    return Column(
      children: bankingGroups
          .map((e) => ListTile(
                onTap: () {
                  goTo(
                      context: context,
                      routeName: ViewBankingGroupScreen.routeName,
                      arguments: ArgumentsViewBankingGroup(id: e.id!));
                },
                leading: const Icon(Icons.group),
                title: Text(e.name),
              ))
          .toList(),
    );
  }
}
