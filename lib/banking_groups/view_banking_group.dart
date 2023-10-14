import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/banking_group_members.dart';
import 'package:myvb/core/widgets/banking_group_transactions.dart';

class ViewBankingGroupScreen extends StatefulWidget {
  static const routeName = '/banking_group/view';
  const ViewBankingGroupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewBankingGroupState();
  }
}

class _ViewBankingGroupState extends State<ViewBankingGroupScreen> {
  Future<BankingGroup?> bankingGroup = Future.value(null);

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
            FutureBuilder(
                future: bankingGroup,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return const Text('Banking group not found!');
                    } else {
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.tag),
                            title: const Text('ID'),
                            trailing: Text(snapshot.data!.id!),
                          ),
                          ListTile(
                            title: const Text('Name'),
                            trailing: Text(snapshot.data!.name),
                          ),
                          ListTile(
                            leading: const Icon(Icons.money),
                            title: const Text('Investment Balance'),
                            trailing: Text(snapshot.data!
                                .totalInvestmentBalance()
                                .toString()),
                          ),
                          BankingGroupMembers(bankingGroup: snapshot.data!),
                          BankingGroupTransactions(
                              bankingGroupId: snapshot.data!.id!),
                        ],
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
