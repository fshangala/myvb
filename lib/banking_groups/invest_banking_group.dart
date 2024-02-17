import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_invest_arguments.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/banking_group_invest_form.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class InvestBankingGroup extends StatefulWidget {
  static const routeName = '/banking-group/invest';
  const InvestBankingGroup({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InvestBankingGroupState();
  }
}

class _InvestBankingGroupState extends AuthState<InvestBankingGroup> {
  Future<VBGroup?> bankingGroup = Future.value(null);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments
        as ArgumentsBankingGroupInvestScreen;
    return AppScaffold(title: 'Invest', onRefresh: () {}, children: [
      Column(
        children: [_renderInvestForm(args.bankingGroupId)],
      ),
    ]);
  }

  Widget _renderInvestForm(String bankingGroupId) {
    bankingGroup =
        VBGroup().getObject(QueryBuilder().where('id', bankingGroupId));
    return NullFutureRenderer(
        future: bankingGroup,
        futureRenderer: (bankingGroupObject) {
          return BankingGroupInvestForm(
            user: user!,
            bankingGroup: bankingGroupObject,
          );
        });
  }
}
