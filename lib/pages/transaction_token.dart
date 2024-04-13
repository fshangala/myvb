import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/transaction_token.dart';
import 'package:myvb/core/dpogroup.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';
import 'package:xml/xml.dart';

class TransactionTokenPageArguments {
  String tokenId;
  TransactionTokenPageArguments({required this.tokenId});
}

class TransactionTokenPage extends StatefulWidget {
  static const routeName = "/transaction-token-page";
  const TransactionTokenPage({super.key});

  get bankingGroup => null;

  @override
  State<StatefulWidget> createState() {
    return _TransactionTokenPage();
  }
}

class _TransactionTokenPage extends AuthState<TransactionTokenPage> {
  Future<TransactionToken?> transactionTokenFuture = Future.value(null);
  final _formkey = GlobalKey<FormState>();
  var accountNumber = TextEditingController(text: '');
  var mobilePayment = 'AirtelZM';
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments
        as TransactionTokenPageArguments;
    transactionTokenFuture =
        TransactionToken().getObject(QueryBuilder().where("id", args.tokenId));
    return AppScaffold(title: 'Transaction', onRefresh: () {}, children: [
      NullFutureRenderer(
        future: transactionTokenFuture,
        futureRenderer: (transactionToken) {
          return Column(
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(transactionToken.amount.toString()),
                      trailing: transactionToken.paid
                          ? const Text("PAID")
                          : const Text("Not PAID"),
                    ),
                    transactionToken.paid
                        ? const Column()
                        : ElevatedButton(
                            onPressed: () {
                              resolveFuture(
                                context,
                                verifyPayment(transactionToken),
                                (value) {
                                  if (value == null) {
                                    displayRegularSnackBar(context, "Faild!");
                                  } else {
                                    displayRegularSnackBar(
                                      context,
                                      value
                                          .findAllElements("ResultExplanation")
                                          .single
                                          .innerText,
                                    );
                                    if (value
                                            .findAllElements("Result")
                                            .single
                                            .innerText !=
                                        "000") {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Try Again"),
                                            content: Form(
                                              key: _formkey,
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: DropdownButton<
                                                            String>(
                                                          value: mobilePayment,
                                                          items:
                                                              getMobilePaymentOptions()
                                                                  .map(
                                                                    (e) => DropdownMenuItem<
                                                                        String>(
                                                                      value: e,
                                                                      child:
                                                                          Text(
                                                                              e),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                          onChanged: (value) {
                                                            if (value != null) {
                                                              mobilePayment =
                                                                  value;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                                  label: Text(
                                                                      'Account Number')),
                                                          controller:
                                                              accountNumber,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _pay(token: transactionToken);
                                                },
                                                child: const Text("Pay"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                              );
                            },
                            child: const Text("Verify or Try again"),
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ]);
  }

  Future<XmlDocument?> requestPayment({
    required String bankingGroupId,
    required String userId,
    required double amount,
    required String email,
    required String phoneNumber,
    required String mobileNumberOperator,
  }) async {
    var dpogroup = Dpogroup();
    var token = await dpogroup.createToken(
      bankingGroupId: bankingGroupId,
      userId: userId,
      amount: amount,
      email: email,
    );
    if (token == null) {
      return null;
    } else {
      return await dpogroup.chargeTokenMobile(
        token: token.token,
        phoneNumber: phoneNumber,
        mobileNumberOperator: mobileNumberOperator,
      );
    }
  }

  void _pay({required TransactionToken token}) {
    var dpogroup = Dpogroup();
    resolveFuture(
        context,
        dpogroup.chargeTokenMobile(
          token: token.token,
          phoneNumber: accountNumber.text,
          mobileNumberOperator: mobilePayment,
        ), (value) {
      displayRegularSnackBar(context,
          value!.findAllElements("ResultExplanation").single.innerText);
      resolveFuture(
        context,
        verifyPayment(token),
        (value) {},
        message: "Verifying...",
      );
    }, message: "Charging...");
  }

  List<String> getMobilePaymentOptions() {
    return ['AirtelZM', 'MTNZM'];
  }

  Future<XmlDocument?> verifyPayment(TransactionToken transactionToken) async {
    var dpogroup = Dpogroup();
    var verification =
        await dpogroup.verifyTransactionToken(token: transactionToken.token);
    if (verification == null) {
      return null;
    } else {
      if (verification.findAllElements("Result").single.innerText == "000") {
        var transaction = VBGroupTransaction().create(
          VBGroupTransactionModelArguments(
            bankingGroupId: transactionToken.bankingGroupId,
            userId: transactionToken.userId,
            email: transactionToken.email,
            amount: double.parse(verification
                .findAllElements("TransactionNetAmount")
                .single
                .innerText),
            approved: true,
          ),
        );
        await transaction.save();
        transactionToken.paid = true;
        await transactionToken.save();
      }
      return verification;
    }
  }
}
