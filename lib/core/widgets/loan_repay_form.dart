import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';

class LoanRepayForm extends StatefulWidget {
  final VBGroupMember bankingGroupMember;
  final VBGroup bankingGroup;
  const LoanRepayForm(
      {super.key,
      required this.bankingGroup,
      required this.bankingGroupMember});

  @override
  State<StatefulWidget> createState() {
    return _LoanRepayForm();
  }
}

class _LoanRepayForm extends State<LoanRepayForm> {
  final _formKey = GlobalKey<FormState>();
  var amount = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            NotNullFutureRenderer(
                future: widget.bankingGroupMember.loanBalance(),
                futureRenderer: (loanBalance) {
                  return Container(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null) {
                            if (double.parse(value) > loanBalance) {
                              return 'Amount cannot be greater than $loanBalance';
                            }
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text('Amount')),
                        controller: amount,
                      ));
                }),
            Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('Repay loan'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _repayLoan();
                    }
                  },
                ))
          ],
        ));
  }

  void _repayLoan() {
    var repayAmount = -1 * double.parse(amount.text);
    resolveFuture(context, widget.bankingGroupMember.getLatestLoan(),
        (latestLoan) {
      var repayment = BankingGroupLoan().create(BankingGroupLoanModelArguments(
          referenceLoanId: latestLoan!.id!,
          bankingGroupId: widget.bankingGroupMember.bankingGroupId,
          userId: widget.bankingGroupMember.userId,
          username: widget.bankingGroupMember.username,
          amount: repayAmount,
          loanInterest: widget.bankingGroup.investmentInterest,
          period: widget.bankingGroup.loanPeriod,
          issuedAt: latestLoan.issuedAt,
          timestamp: DateTime.now(),
          approved: true));
      resolveFuture(context, repayment.save(), (loan) {
        displayRegularSnackBar(context, 'Amount Submitted');
        Navigator.pop(context);
      });
    });
  }
}
