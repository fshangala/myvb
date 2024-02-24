import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_loan.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/resolve_future.dart';

class LoanRequestForm extends StatefulWidget {
  final VBGroup bankingGroup;
  final VBGroupMember bankingGroupMember;
  const LoanRequestForm(
      {super.key,
      required this.bankingGroup,
      required this.bankingGroupMember});

  @override
  State<StatefulWidget> createState() {
    return _LoanRequestForm();
  }
}

class _LoanRequestForm extends State<LoanRequestForm> {
  final _formKey = GlobalKey<FormState>();
  var amount = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: const InputDecoration(label: Text('Amount')),
                  controller: amount,
                )),
            Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('Request loan'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _requestLoan();
                    }
                  },
                ))
          ],
        ));
  }

  void _requestLoan() {
    resolveFuture(context, widget.bankingGroup.totalIvenstmentBalance(),
        (groupInvestmentBalance) {
      if (double.parse(amount.text) > groupInvestmentBalance) {
        displayRegularSnackBar(
            context, 'Loan amount cannot be more than $groupInvestmentBalance');
      } else {
        var loanAmount = double.parse(amount.text);
        var loanInterestAmount =
            loanAmount * widget.bankingGroup.investmentInterest * 0.01;
        var loan = BankingGroupLoan().create(BankingGroupLoanModelArguments(
            bankingGroupId: widget.bankingGroupMember.bankingGroupId,
            userId: widget.bankingGroupMember.userId,
            email: widget.bankingGroupMember.email,
            amount: loanAmount,
            loanInterest: widget.bankingGroup.investmentInterest,
            period: widget.bankingGroup.loanPeriod,
            issuedAt: DateTime.now(),
            timestamp: DateTime.now(),
            approved: true));
        resolveFuture(context, loan.save(), (value) {
          var loanInterest = BankingGroupLoan().create(
              BankingGroupLoanModelArguments(
                  referenceLoanId: value?.id,
                  bankingGroupId: widget.bankingGroupMember.bankingGroupId,
                  userId: widget.bankingGroupMember.userId,
                  email: widget.bankingGroupMember.email,
                  amount: loanInterestAmount,
                  loanInterest: widget.bankingGroup.investmentInterest,
                  period: widget.bankingGroup.loanPeriod,
                  issuedAt: value!.issuedAt,
                  timestamp: DateTime.now(),
                  approved: true));
          resolveFuture(context, loanInterest.save(), (value2) {
            displayRegularSnackBar(
                context, 'Loan interest successfully added!');
            setState(() {
              amount.text = '';
            });
          }, message: 'Adding loan interest');
        }, message: 'Requesting loan');
      }
    }, message: 'Collecting total investments');
  }
}
