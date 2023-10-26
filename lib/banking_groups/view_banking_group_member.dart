import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_group_member_arguments.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/banking_group_view_member.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class ViewBankingGroupMember extends StatefulWidget {
  const ViewBankingGroupMember({super.key});
  static const routeName = '/banking_group/member';

  @override
  State<StatefulWidget> createState() {
    return _ViewBankingGroupMember();
  }
}

class _ViewBankingGroupMember extends AuthState<ViewBankingGroupMember> {
  Future<VBGroup?> bankingGroup = Future.value(null);

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsViewGroupMember;
    bankingGroup =
        VBGroup().getObject(QueryBuilder().where('id', args.bankingGroupId));
    return AppScaffold(title: 'Group Member', children: [
      NullFutureRenderer(
          future: user,
          futureRenderer: (userObject) {
            return Column(
              children: [
                NullFutureRenderer(
                    future: bankingGroup,
                    futureRenderer: (bankingGroupObject) {
                      return BankingGroupViewMember(
                          luser: userObject,
                          bankingGroup: bankingGroupObject,
                          userId: args.userId);
                    })
              ],
            );
          })
    ]);
  }
}
