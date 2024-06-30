import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/loan_repay_form.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class RepayLoanScreenArguments {
  String bankingGroupId;
  RepayLoanScreenArguments({required this.bankingGroupId});
}

class RepayLoanScreen extends StatefulWidget {
  const RepayLoanScreen({super.key});

  static const routeName = 'banking_group/member/repay_loan';

  @override
  State<StatefulWidget> createState() {
    return _RepayLoanScreen();
  }
}

class _RepayLoanScreen extends AuthState<RepayLoanScreen> {
  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as RepayLoanScreenArguments;
    return AppScaffold(title: 'Repay Loan', onRefresh: () {}, children: [
      NullFutureRenderer(
          future: VBGroup()
              .getObject(QueryBuilder().where('id', args.bankingGroupId)),
          futureRenderer: (bankingGroup) {
            return NullFutureRenderer(
                future: bankingGroup.groupMember(user!.id),
                futureRenderer: (groupMember) {
                  return Column(
                    children: [
                      LoanRepayForm(
                        bankingGroupMember: groupMember,
                        bankingGroup: bankingGroup,
                      )
                    ],
                  );
                });
          }),
    ]);
  }
}
