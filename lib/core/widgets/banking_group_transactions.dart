import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';

class BankingGroupTransactions extends StatefulWidget {
  final String bankingGroupId;
  const BankingGroupTransactions({super.key, required this.bankingGroupId});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupTransactions();
  }
}

class _BankingGroupTransactions extends State<BankingGroupTransactions> {
  late Future<List<VBGroupTransaction>> transactions;
  @override
  void initState() {
    super.initState();
    transactions = VBGroupTransaction().getObjects(
        QueryBuilder().where('bankingGroupId', widget.bankingGroupId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('Banking Group Transactions'),
        ),
        FutureBuilder(
            future: transactions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const ListTile(
                    title: Text('No transactions'),
                  );
                }
                return _renderTransactions(snapshot.data!);
              } else if (snapshot.hasError) {
                return ListTile(
                  title: const Text('Error'),
                  subtitle: Text('${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        ListTile(
          title: const Text('RELOAD'),
          trailing: const Icon(Icons.repeat),
          onTap: () {
            transactions = VBGroupTransaction().getObjects(
                QueryBuilder().where('bankingGroupId', widget.bankingGroupId));
          },
        )
      ],
    );
  }

  Column _renderTransactions(
      List<VBGroupTransaction> bankingGroupTransactions) {
    var tiles = bankingGroupTransactions.map((e) {
      var approved = 'Pending';
      if (e.approved) {
        approved = 'Approved';
      }
      return ListTile(
        title: Text(e.username),
        subtitle: Text(approved),
        trailing: Text(e.amount.toString()),
      );
    }).toList();
    return Column(
      children: tiles,
    );
  }
}
