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
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyVB: Home'),
      ),
    );
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
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return userWidget((luser) {
      userBankingGroupsFuture = userBankingGroups(luser.id);
      return Scaffold(
        appBar: appBar(context, 'Home'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.pushNamed(context, CreateBankingGroup.routeName);
          },
          tooltip: 'Create Banking Group',
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              userBankingGroupsFuture = userBankingGroups(luser.id);
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
          .map((e) => Container(
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: ListTile(
                  onTap: () {
                    /* goTo(
                        context: context,
                        routeName: ViewBankingGroupScreen.routeName,
                        arguments: ArgumentsViewBankingGroup(id: e.id!)); */
                  },
                  leading: const Icon(Icons.group),
                  title: Text(e.name),
                  trailing: const Icon(Icons.arrow_forward),
                  style: ListTileStyle.list,
                  tileColor: Theme.of(context).colorScheme.background,
                ),
              ))
          .toList(),
    );
  }
}
