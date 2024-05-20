import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/invest_banking_group.dart';
import 'package:myvb/banking_groups/screen_repay_loan.dart';
import 'package:myvb/banking_groups/screen_request_loan.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_invest_arguments.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_banking_group_screen_arguments.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';
import 'package:myvb/home/home.dart';
import 'package:myvb/users/profile.dart';

class ViewBankingGroupScreen extends StatefulWidget {
  static const routeName = '/banking_group/view';
  const ViewBankingGroupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewBankingGroupState2();
  }
}

class _ViewBankingGroupState2 extends AuthState<ViewBankingGroupScreen> {
  var vbGroup = VBGroup();
  Future<VBGroup?> bankingGroupFuture = Future.value(null);
  final _formKey = GlobalKey<FormState>();
  var userEmail = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsViewBankingGroup;
    bankingGroupFuture = vbGroup.getObject(QueryBuilder().where('id', args.id));
    return userWidget((luser) {
      return NullFutureRenderer(
          future: bankingGroupFuture,
          futureRenderer: (bankingGroup) {
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('MyVB - ${bankingGroup.name}'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        goTo(
                            context: context,
                            routeName: HomeScreen.routeName,
                            permanent: true);
                      },
                      icon: const Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {
                        goTo(
                            context: context,
                            routeName: ProfileScreen.routeName,
                            permanent: false);
                      },
                      icon: const Icon(Icons.person),
                    )
                  ],
                  bottom: const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.summarize),
                        text: 'Overview',
                      ),
                      Tab(
                        icon: Icon(Icons.group),
                        text: 'Members',
                      ),
                      Tab(
                        icon: Icon(Icons.monetization_on),
                        text: 'Transactions',
                      ),
                      Tab(
                        icon: Icon(Icons.money),
                        text: 'Loans',
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    RefreshIndicator(
                        child: ListView(
                          children: [
                            NullFutureRenderer(
                              future: bankingGroup.groupMember(luser.uid),
                              futureRenderer: (bankingGroupMember) {
                                return Row(
                                  children: [
                                    Card(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            NotNullFutureRenderer(
                                              future: bankingGroupMember
                                                  .investmentBalance(),
                                              futureRenderer:
                                                  (investmentBalance) {
                                                return Text(
                                                  "K ${investmentBalance.toString()}",
                                                  style: const TextStyle(
                                                      fontSize: 24.0),
                                                );
                                              },
                                            ),
                                            const Text(
                                              "My Investments",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.group),
                                    title: Text(bankingGroup.name),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title:
                                              const Text('Total Investments'),
                                          subtitle: NotNullFutureRenderer(
                                            future: bankingGroup
                                                .totalIvenstmentBalance(),
                                            futureRenderer:
                                                (totalInvestmentBalance) {
                                              return Text(
                                                  '$totalInvestmentBalance ZMW');
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Investment Cycle'),
                                          subtitle: Text(
                                              '${bankingGroup.investmentCycle} days'),
                                        ),
                                        ListTile(
                                          title: const Text('Load Period'),
                                          subtitle: Text(
                                              '${bankingGroup.loanPeriod} days'),
                                        ),
                                        ListTile(
                                          title: const Text('Interest'),
                                          subtitle: Text(
                                              '${bankingGroup.investmentInterest}%'),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                goTo(
                                                  context: context,
                                                  routeName: InvestBankingGroup
                                                      .routeName,
                                                  permanent: false,
                                                  arguments:
                                                      ArgumentsBankingGroupInvestScreen(
                                                          bankingGroup.id!),
                                                );
                                              },
                                              child: const Text('Invest'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                goTo(
                                                  context: context,
                                                  routeName: ScreenRequestLoan
                                                      .routeName,
                                                  permanent: false,
                                                  arguments:
                                                      ArgumentsScreenRequestLoan(
                                                    bankingGroupId:
                                                        bankingGroup.id!,
                                                    bankingGroupMemberId:
                                                        luser.uid,
                                                  ),
                                                );
                                              },
                                              child: const Text('Get Loan'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onRefresh: () async {
                          setState(() {
                            bankingGroupFuture = vbGroup
                                .getObject(QueryBuilder().where('id', args.id));
                          });
                        }),
                    RefreshIndicator(
                      child: ListView(
                        children: [
                          luser.uid == bankingGroup.owner
                              ? Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            label: const Text('User email'),
                                            suffix: ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  resolveFuture(
                                                      context,
                                                      bankingGroup.addMember(
                                                          userEmail.text),
                                                      (value) {
                                                    displayRegularSnackBar(
                                                        context,
                                                        value == null
                                                            ? 'Could not add ${value!.email}'
                                                            : '${value.email} added!');
                                                  });
                                                }
                                              },
                                              child: const Text('Add'),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: userEmail,
                                          validator: (value) {
                                            if (value == "") {
                                              return 'User email cannot be empty!';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Column(),
                          NotNullFutureRenderer(
                            future: bankingGroup.groupMembers(null),
                            futureRenderer: (groupMembers) {
                              return Column(
                                children: groupMembers.map(
                                  (e) {
                                    return ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(e.email),
                                    );
                                  },
                                ).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                      onRefresh: () async {
                        setState(() {
                          bankingGroupFuture = vbGroup
                              .getObject(QueryBuilder().where('id', args.id));
                        });
                      },
                    ),
                    RefreshIndicator(
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: NotNullFutureRenderer(
                              future: bankingGroup.transactions(),
                              futureRenderer: (bankingGroupTransactions) {
                                return bankingGroupTransactions.isEmpty
                                    ? const Text('No transactions.')
                                    : Scrollbar(
                                        child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(label: Text('User')),
                                            DataColumn(label: Text('Amount')),
                                            DataColumn(label: Text('Status')),
                                          ],
                                          rows: bankingGroupTransactions
                                              .map(
                                                (e) => DataRow(
                                                  cells: [
                                                    DataCell(Text(e.email)),
                                                    DataCell(Text(
                                                        '${e.amount} ZMW')),
                                                    DataCell(Text(e.approved
                                                        ? 'APPROVED'
                                                        : 'PENDING')),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ));
                              },
                            ),
                          ),
                        ],
                      ),
                      onRefresh: () async {
                        setState(() {
                          bankingGroupFuture = vbGroup
                              .getObject(QueryBuilder().where('id', args.id));
                        });
                      },
                    ),
                    RefreshIndicator(
                      child: ListView(
                        children: [
                          NullFutureRenderer(
                            future: bankingGroup
                                .getGroupMemberLoanBalance(luser.uid),
                            futureRenderer: (groupMemberLoanBalance) {
                              return ListTile(
                                leading: const Icon(Icons.money),
                                title: Text('$groupMemberLoanBalance ZMW'),
                                subtitle: const Text('Latest Loan Balance'),
                                trailing: ElevatedButton(
                                  child: const Text('Payback'),
                                  onPressed: () {
                                    goTo(
                                        context: context,
                                        routeName: RepayLoanScreen.routeName,
                                        permanent: false,
                                        arguments: RepayLoanScreenArguments(
                                            bankingGroupId: bankingGroup.id!));
                                  },
                                ),
                              );
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: NotNullFutureRenderer(
                              future:
                                  bankingGroup.getGroupMemberLoans(luser.uid),
                              futureRenderer: (bankingGroupMember) {
                                bankingGroupMember.sort((a, b) {
                                  return -a.issuedAt.compareTo(b.issuedAt);
                                });
                                return bankingGroupMember.isEmpty
                                    ? const Text('No loans.')
                                    : Scrollbar(
                                        child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(label: Text('Amount')),
                                            DataColumn(
                                                label: Text('Issued at')),
                                            DataColumn(
                                                label: Text('Timestamp')),
                                            DataColumn(label: Text('Status')),
                                          ],
                                          rows: bankingGroupMember
                                              .map(
                                                (e) => DataRow(
                                                  cells: [
                                                    DataCell(Text(
                                                        '${e.amount} ZMW')),
                                                    DataCell(Text(
                                                        e.issuedAt.toString())),
                                                    DataCell(Text(e.timestamp
                                                        .toString())),
                                                    DataCell(Text(e.approved
                                                        ? 'APPROVED'
                                                        : 'PENDING')),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ));
                              },
                            ),
                          ),
                        ],
                      ),
                      onRefresh: () async {
                        setState(() {
                          bankingGroupFuture = vbGroup
                              .getObject(QueryBuilder().where('id', args.id));
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
