import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/view_group_member_arguments.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/banking_group_view_member.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class ViewBankingGroupMemberScreen extends StatelessWidget {
  const ViewBankingGroupMemberScreen({super.key});
  static const routeName = '/banking_group/member';

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as ArgumentsViewGroupMember;
    return AppScaffold(title: 'Group Member', children: [
      ViewBankingGroupMember(
        bankingGroupId: args.bankingGroupId,
        userId: args.userId,
      ),
    ]);
  }
}

class ViewBankingGroupMember extends StatefulWidget {
  final String bankingGroupId;
  final String userId;
  const ViewBankingGroupMember(
      {super.key, required this.bankingGroupId, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return _ViewBankingGroupMember();
  }
}

class _ViewBankingGroupMember extends AuthState<ViewBankingGroupMember> {
  late Future<VBGroup?> bankingGroup;

  @override
  void afterInit() {
    super.afterInit();
    getBankingGroup();
  }

  @override
  Widget build(BuildContext context) {
    return NullFutureRenderer(
        future: user,
        futureRenderer: (userObject) {
          return Column(
            children: [
              NullFutureRenderer(
                  future: bankingGroup,
                  futureRenderer: (bankingGroupObject) {
                    return Column(
                      children: [
                        BankingGroupViewMember(
                            luser: userObject,
                            bankingGroup: bankingGroupObject,
                            userId: widget.userId)
                      ],
                    );
                  })
            ],
          );
        });
  }

  void getBankingGroup() {
    bankingGroup =
        VBGroup().getObject(QueryBuilder().where('id', widget.bankingGroupId));
  }
}
