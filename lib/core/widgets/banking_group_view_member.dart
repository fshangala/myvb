import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myvb/banking_groups/invest_banking_group.dart';
import 'package:myvb/banking_groups/screen_request_loan.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_invest_arguments.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/banking_group_member_loans.dart';
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
          title: const Text('Banking Group'),
          subtitle: Text(widget.bankingGroup.id!),
          trailing: Text(widget.bankingGroup.name),
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.bankingGroup.id!)).then((value) {
              displayRegularSnackBar(context, 'ID copied to clipboard!');
            });
          },
        ),
        NullFutureRenderer(
            future: member,
            futureRenderer: (groupMember) {
              var userWidget = const Column();

              //approved member
              if (groupMember.approved) {
                //member is viewing their own
                if (widget.luser.uid == widget.userId) {
                  userWidget = Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
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
                          ),
                          ElevatedButton(
                              onPressed: () {
                                goTo(
                                    context: context,
                                    routeName: ScreenRequestLoan.routeName,
                                    arguments: ArgumentsScreenRequestLoan(
                                        bankingGroupId: widget.bankingGroup.id!,
                                        bankingGroupMemberId: groupMember.userId),
                                    permanent: false);
                              },
                              child: const Text('Request loan')),
                        ],
                      ),
                      VBGroupMemberTransactions(member: groupMember),
                      VBGroupMemberLoans(groupMember: groupMember)
                    ],
                  );
                }
              } else {
                if (widget.luser.uid == widget.bankingGroup.owner) {
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
                    title: Text(groupMember.email),
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
    member = widget.bankingGroup.groupMember(widget.userId);
  }
}
