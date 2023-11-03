import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/screen_repay_loan.dart';
import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';

class VBGroupMemberLoans extends StatefulWidget {
  final VBGroupMember groupMember;
  const VBGroupMemberLoans({super.key, required this.groupMember});

  @override
  State<StatefulWidget> createState() {
    return _VBGroupMemberLoansState();
  }
}

class _VBGroupMemberLoansState extends State<VBGroupMemberLoans> {
  late Future<List<BankingGroupLoan>> loansFuture;
  @override
  void initState() {
    super.initState();
    getLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Member Loans'),
        NotNullFutureRenderer(
            future: loansFuture,
            futureRenderer: (loans) {
              return DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Timestamp')),
                    DataColumn(label: Text('Approved'))
                  ],
                  rows: loans
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e.id!)),
                            DataCell(Text(e.username)),
                            DataCell(Text(e.amount.toString())),
                            DataCell(Text(e.timestamp.toString())),
                            DataCell(Text(e.approved.toString()))
                          ]))
                      .toList());
            }),
        NotNullFutureRenderer(
          future: widget.groupMember.loanBalance(),
          futureRenderer: (balance) {
            Widget subtitle = const Text('No balance to settle');
            if (balance > 0) {
              subtitle = ElevatedButton(
                  onPressed: () {
                    goTo(
                        context: context,
                        routeName: RepayLoanScreen.routeName,
                        permanent: false,
                        arguments: RepayLoanScreenArguments(
                            bankingGroupId: widget.groupMember.bankingGroupId));
                  },
                  child: const Text('Repay loan'));
            }
            return ListTile(
              title: const Text('Balance'),
              subtitle: subtitle,
              trailing: Text(balance.toString()),
            );
          },
        ),
        ListTile(
          title: const Text('RELOAD'),
          trailing: const Icon(Icons.repeat),
          onTap: () {
            setState(() {
              getLoans();
            });
          },
        )
      ],
    );
  }

  void getLoans() {
    loansFuture = BankingGroupLoan().getObjects(QueryBuilder()
        .where('bankingGroupId', widget.groupMember.bankingGroupId)
        .where('userId', widget.groupMember.userId));
  }
}
