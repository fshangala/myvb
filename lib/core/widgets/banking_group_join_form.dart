import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/functions/go_to.dart';

class BankingGroupJoinForm extends StatefulWidget {
  final String userId;
  final String username;
  const BankingGroupJoinForm(
      {super.key, required this.userId, required this.username});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupJoinForm();
  }
}

class _BankingGroupJoinForm extends State<BankingGroupJoinForm> {
  final _formKey = GlobalKey<FormState>();
  Future<BankingGroup?> bankingGroup = Future.value(null);
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
                TextFormField(
                  decoration: const InputDecoration(label: Text('Search')),
                  controller: searchController,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        bankingGroup =
                            BankingGroup.getById(searchController.text);
                      });
                    },
                    child: const Text('Search'))
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

  Widget _renderBankingGroup(BankingGroup group) {
    return ListTile(
      title: Text(group.name),
      trailing: TextButton(
        child: const Text('Join'),
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: ((context) {
                return const Dialog(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }));
          group.joinGroup(widget.userId, widget.username).then((value) {
            Navigator.pop(context);
            if (value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${value.username} Joined!')));
              goTo(
                  context: context,
                  routeName: ViewBankingGroupScreen.routeName,
                  arguments: ArgumentsViewBankingGroup(id: value.id!));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not join group!')));
            }
          }).onError((error, stackTrace) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Error: $error')));
          });
        },
      ),
    );
  }
}
