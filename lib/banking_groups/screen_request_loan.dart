import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/loan_request_form.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class ArgumentsScreenRequestLoan {
  String bankingGroupId;
  String bankingGroupMemberId;
  ArgumentsScreenRequestLoan(
      {required this.bankingGroupId, required this.bankingGroupMemberId});
}

class ScreenRequestLoan extends StatefulWidget {
  const ScreenRequestLoan({super.key});
  static const routeName = '/banking-group/request-loan';

  @override
  State<StatefulWidget> createState() {
    return _StateRequestLoan();
  }
}

class _StateRequestLoan extends AuthState<ScreenRequestLoan> {
  Future<VBGroup?> bankingGroup = Future.value(null);
  Future<VBGroupMember?> bankingGroupMember = Future.value(null);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ArgumentsScreenRequestLoan;
    bankingGroup =
        VBGroup().getObject(QueryBuilder().where('id', args.bankingGroupId));
    return AppScaffold(title: 'Request loan', children: [
      NullFutureRenderer(
        future: bankingGroup,
        futureRenderer: (bankingGroupObject) {
          bankingGroupMember = bankingGroupObject.groupMember(args.bankingGroupMemberId);
          return NullFutureRenderer(
            future: bankingGroupMember,
            futureRenderer: (bankingGroupMemberObject) {
              return Column(
                children: [
                  LoanRequestForm(
                    bankingGroup: bankingGroupObject,
                    bankingGroupMember: bankingGroupMemberObject,
                  )
                ],
              );
            },
          );
        },
      ),
    ]);
  }
}
