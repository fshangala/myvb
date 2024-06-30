import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';

class BankingGroupsByUser extends StatefulWidget {
  final String userId;
  const BankingGroupsByUser({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupByUserState();
  }
}

class _BankingGroupByUserState extends State<BankingGroupsByUser> {
  late Future<List<VBGroup>> bankingGroups;

  @override
  void initState() {
    super.initState();
    getBankingGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('My Banking Groups'),
        NotNullFutureRenderer(
            future: bankingGroups,
            futureRenderer: (objects) {
              return _renderBankingGroups(objects);
            }),
      ],
    );
  }

  Widget _renderBankingGroups(List<VBGroup> groups) {
    var tiles = groups
        .map((e) => ListTile(
              title: Text(e.name),
              onTap: () {
                /* goTo(
                    context: context,
                    routeName: ViewBankingGroupScreen.routeName,
                    permanent: false,
                    arguments: ArgumentsViewBankingGroup(id: e.id!)); */
              },
            ))
        .toList();

    tiles.add(ListTile(
      title: const Text('RELOAD'),
      onTap: () {
        setState(() {
          getBankingGroups();
        });
      },
    ));

    return Column(children: tiles);
  }

  void getBankingGroups() {
    bankingGroups =
        VBGroup().getObjects(QueryBuilder().where('owner', widget.userId));
  }
}
