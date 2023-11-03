import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/view_banking_group_member.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/view_group_member_arguments.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';

class BankingGroupMembers extends StatefulWidget {
  final VBGroup bankingGroup;
  const BankingGroupMembers({super.key, required this.bankingGroup});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupMembersState();
  }
}

class _BankingGroupMembersState extends State<BankingGroupMembers> {
  late Future<List<VBGroupMember>> groupMembers;
  bool? approved;

  @override
  void initState() {
    super.initState();
    groupMembers = widget.bankingGroup.groupMembers(approved);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Members'),
        Row(
          children: [
            const Expanded(child: Text('Filter Status')),
            DropdownButton(
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'approved', child: Text('Approved')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                ],
                onChanged: ((value) {
                  switch (value) {
                    case 'all':
                      setState(() {
                        approved = null;
                        groupMembers =
                            widget.bankingGroup.groupMembers(approved);
                      });
                      break;
                    case 'approved':
                      setState(() {
                        approved = true;
                        groupMembers =
                            widget.bankingGroup.groupMembers(approved);
                      });
                      break;
                    case 'pending':
                      setState(() {
                        approved = false;
                        groupMembers =
                            widget.bankingGroup.groupMembers(approved);
                      });
                      break;

                    default:
                      setState(() {
                        approved = null;
                        groupMembers =
                            widget.bankingGroup.groupMembers(approved);
                      });
                      break;
                  }
                }))
          ],
        ),
        NotNullFutureRenderer(
            future: groupMembers,
            futureRenderer: (members) {
              if (members.isEmpty) {
                return const ListTile(
                  title: Text('No members to show'),
                );
              } else {
                return Column(
                  children: members
                      .map((e) => ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(e.username),
                            onTap: () {
                              goTo(
                                  context: context,
                                  routeName:
                                      ViewBankingGroupMemberScreen.routeName,
                                  arguments: ArgumentsViewGroupMember(
                                      e.bankingGroupId, e.userId),
                                  permanent: false);
                            },
                          ))
                      .toList(),
                );
              }
            }),
      ],
    );
  }
}
