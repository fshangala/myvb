import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/invest_banking_group.dart';
import 'package:myvb/banking_groups/screen_request_loan.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_invest_arguments.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/banking_group_member_transactions.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class BankingGroupViewMember extends StatefulWidget {
  final User luser;
  final VBGroup bankingGroup;
  final String userId;
  const BankingGroupViewMember(
      {super.key,
      required this.luser,
      required this.bankingGroup,
      required this.userId});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupViewMember();
  }
}

class _BankingGroupViewMember extends State<BankingGroupViewMember> {
  late Future<VBGroupMember?> member;
  @override
  void initState() {
    super.initState();
    getGroupMember();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text(widget.bankingGroup.id!),
          title: Text(widget.bankingGroup.name),
        ),
        NullFutureRenderer(
            future: member,
            futureRenderer: (groupMember) {
              var userWidget = const Column();

              //approved member
              if (groupMember.approved) {
                //member is viewing their own
                if (widget.luser.id == widget.userId) {
                  userWidget = Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                goTo(
                                    context: context,
                                    routeName: InvestBankingGroup.routeName,
                                    arguments:
                                        ArgumentsBankingGroupInvestScreen(
                                            widget.bankingGroup.id!),
                                    permanent: false);
                              },
                              child: const Text('Invest')),
                          ElevatedButton(
                              onPressed: () {
                                goTo(
                                    context: context,
                                    routeName: ScreenRequestLoan.routeName,
                                    permanent: false);
                              },
                              child: const Text('Request loan')),
                        ],
                      ),
                      VBGroupMemberTransactions(member: groupMember)
                    ],
                  );
                }
              } else {
                if (widget.luser.id == widget.bankingGroup.owner) {
                  userWidget = Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            resolveFuture(context, groupMember.approve(),
                                (value) {
                              setState(() {
                                member = widget.bankingGroup
                                    .groupMember(widget.userId);
                              });
                            });
                          },
                          child: const Text('Approve member'))
                    ],
                  );
                }
              }
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(groupMember.username),
                    subtitle: NotNullFutureRenderer(
                      future: groupMember.investmentBalance(),
                      futureRenderer: (balance) {
                        return Text('Balance: $balance');
                      },
                    ),
                    trailing: Text(groupMember.approved.toString()),
                  ),
                  userWidget
                ],
              );
            })
      ],
    );
  }

  void getGroupMember() {
    member = VBGroupMember().getObject(QueryBuilder()
        .where('bankingGroupId', widget.bankingGroup.id!)
        .where('userId', widget.userId));
  }
}
