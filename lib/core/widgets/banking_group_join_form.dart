import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';

class BankingGroupJoinForm extends StatefulWidget {
  final User user;
  const BankingGroupJoinForm({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupJoinForm();
  }
}

class _BankingGroupJoinForm extends State<BankingGroupJoinForm> {
  final _formKey = GlobalKey<FormState>();
  Future<VBGroup?> bankingGroup = Future.value(null);
  var searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: const InputDecoration(label: Text('Search')),
                    controller: searchController,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          bankingGroup = VBGroup().getObject(QueryBuilder()
                              .where('id', searchController.text));
                        });
                      },
                      child: const Text('Search')),
                )
              ]),
            )),
        FutureBuilder(
            future: bankingGroup,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Text('No banking group found');
                } else {
                  return _renderBankingGroup(snapshot.data!);
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }

  Widget _renderBankingGroup(VBGroup group) {
    return ListTile(
      title: Text(group.name),
      trailing: TextButton(
        child: const Text('Join'),
        onPressed: () {
          resolveFuture(context, group.joinGroup(widget.user), (value) {
            if (value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${value.email} Joined!')));
              goTo(
                  context: context,
                  routeName: ViewBankingGroupScreen.routeName,
                  arguments: ArgumentsViewBankingGroup(id: value.bankingGroupId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not join group!')));
            }
          });
        },
      ),
    );
  }
}
