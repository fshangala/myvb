import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/functions/go_to.dart';

class BankingGroupsJoined extends StatefulWidget {
  final String username;
  const BankingGroupsJoined({super.key, required this.username});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupJoinedState();
  }
}

class _BankingGroupJoinedState extends State<BankingGroupsJoined> {
  late Future<List<BankingGroup>> bankingGroups;

  @override
  void initState() {
    super.initState();
    bankingGroups = BankingGroup.getUserJoinedBankingGroups(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('My Joined Banking Groups'),
        FutureBuilder(
            future: bankingGroups,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return _renderBankingGroups(snapshot.data!);
              } else if (snapshot.hasError) {
                return ListTile(
                  title: const Text('Error'),
                  subtitle: Text('${snapshot.error}'),
                  trailing: const Text('RELOAD'),
                  onTap: () {
                    setState(() {
                      bankingGroups = BankingGroup.getUserJoinedBankingGroups(
                          widget.username);
                    });
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })),
      ],
    );
  }

  Widget _renderBankingGroups(List<BankingGroup> groups) {
    var tiles = groups
        .map((e) => ListTile(
              title: Text(e.name),
              onTap: () {
                goTo(
                    context: context,
                    routeName: ViewBankingGroupScreen.routeName,
                    permanent: false,
                    arguments: ArgumentsViewBankingGroup(id: e.id!));
              },
            ))
        .toList();

    tiles.add(ListTile(
      title: const Text('RELOAD'),
      onTap: () {
        setState(() {
          bankingGroups =
              BankingGroup.getUserJoinedBankingGroups(widget.username);
        });
      },
    ));

    return Column(children: tiles);
  }
}
