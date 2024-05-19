import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/transaction_token.dart';
import 'package:myvb/core/dpogroup.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';
import 'package:myvb/pages/transaction_token.dart';

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
  var accountNumber = TextEditingController(text: '');
  var mobilePayment = 'AirtelZM';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: DropdownButton<String>(
                value: mobilePayment,
                items: getMobilePaymentOptions()
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    mobilePayment = value;
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration:
                    const InputDecoration(label: Text('Account Number')),
                controller: accountNumber,
              ),
            ),
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

  List<String> getMobilePaymentOptions() {
    return ['AirtelZM', 'MTNZM'];
  }

  Future<TransactionToken?> requestPayment({
    required String bankingGroupId,
    required String userId,
    required double amount,
    required String email,
    required String type,
    required String phoneNumber,
    required String mobileNumberOperator,
  }) async {
    var dpogroup = Dpogroup();
    var token = await dpogroup.createToken(
      bankingGroupId: bankingGroupId,
      userId: userId,
      amount: amount,
      type: type,
      email: email,
    );
    if (token == null) {
      return null;
    } else {
      await dpogroup.chargeTokenMobile(
        token: token.token,
        phoneNumber: phoneNumber,
        mobileNumberOperator: mobileNumberOperator,
      );
      return token;
    }
  }

  void _repayLoan() {
    resolveFuture(
      context,
      requestPayment(
        bankingGroupId: widget.bankingGroup.id!,
        userId: widget.bankingGroupMember.userId,
        amount: double.parse(amount.text),
        email: widget.bankingGroupMember.email,
        type: "loan",
        phoneNumber: accountNumber.text,
        mobileNumberOperator: mobilePayment,
      ),
      (value) {
        if (value != null) {
          goTo(
            context: context,
            routeName: TransactionTokenPage.routeName,
            permanent: true,
            arguments: TransactionTokenPageArguments(tokenId: value.token),
          );
        }
      },
    );
    /*var repayAmount = -1 * double.parse(amount.text);
    resolveFuture(context, widget.bankingGroupMember.getLatestLoan(),
        (latestLoan) {
      var repayment = BankingGroupLoan().create(BankingGroupLoanModelArguments(
          referenceLoanId: latestLoan!.id!,
          bankingGroupId: widget.bankingGroupMember.bankingGroupId,
          userId: widget.bankingGroupMember.userId,
          email: widget.bankingGroupMember.email,
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
    });*/
  }
}
