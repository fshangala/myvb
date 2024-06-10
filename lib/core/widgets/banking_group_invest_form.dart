import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/transaction_token.dart';
import 'package:myvb/core/dpogroup.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:http/http.dart' as http;
import 'package:myvb/pages/transaction_token.dart';

class BankingGroupInvestForm extends StatefulWidget {
  final User user;
  final VBGroup bankingGroup;
  const BankingGroupInvestForm(
      {super.key, required this.user, required this.bankingGroup});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupInvestFormState();
  }
}

class _BankingGroupInvestFormState extends State<BankingGroupInvestForm> {
  final _formkey = GlobalKey<FormState>();
  TransactionToken? transactionToken;
  var investmentAmount = TextEditingController(text: '');
  var accountNumber = TextEditingController(text: '');
  var mobilePayment = 'AirtelZM';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Column(
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
                  decoration: const InputDecoration(
                      label: Text('Account Number'), hintText: "260"),
                  controller: accountNumber,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration:
                      const InputDecoration(label: Text('Investment Amount')),
                  controller: investmentAmount,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('Invest'),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _invest();
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<http.Response> requestMobilePaymentOptions() async {
    var headersList = {
      'Accept': 'application/xml',
      'Content-Type': 'application/xml'
    };
    var url = Uri.parse('https://secure.3gdirectpay.com/API/v6/');

    var body = '''<?xml version="1.0" encoding="utf-8"?>
<API3G>
  <CompanyToken>8D3DA73D-9D7F-4E09-96D4-3D44E7A83EA3</CompanyToken>
  <Request>CompanyMobilePaymentOptions</Request>
</API3G>''';
    var res = await http.post(url, headers: headersList, body: body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      //TODO: Create json list
    }
    return res;
  }

  List<String> getMobilePaymentOptions() {
    //requestMobilePaymentOptions().then((value) => print(value.statusCode));
    return ['AirtelZM', 'MTNZM'];
  }

  /*Future<XmlDocument?> verifyPayment() async {
    var dpogroup = Dpogroup();
    var verification =
        await dpogroup.verifyTransactionToken(token: transactionToken!.token);
    if (verification == null) {
      return null;
    } else {
      if (verification.findAllElements("Result").single.innerText == "000") {
        var transaction = VBGroupTransaction().create(
          VBGroupTransactionModelArguments(
            bankingGroupId: widget.bankingGroup.id!,
            userId: widget.user.uid,
            email: widget.user.email!,
            amount: double.parse(verification
                .findAllElements("TransactionNetAmount")
                .single
                .innerText),
            approved: true,
          ),
        );
        await transaction.save();
        transactionToken!.paid = true;
        transactionToken = await transactionToken!.save();
      } else {
        return await tryAgain();
      }
      return verification;
    }
  }*/

  /*Future<XmlDocument?> tryAgain() async {
    var dpogroup = Dpogroup();
    var token = await dpogroup.chargeTokenMobile(
      token: transactionToken!.token,
      phoneNumber: accountNumber.text,
      mobileNumberOperator: mobilePayment,
    );
    return token;
  }*/

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

  void _invest() {
    resolveFuture(
        context,
        requestPayment(
          bankingGroupId: widget.bankingGroup.id!,
          userId: widget.user.uid,
          amount: double.parse(investmentAmount.text),
          email: widget.user.email!,
          type: "investment",
          phoneNumber: accountNumber.text,
          mobileNumberOperator: mobilePayment,
        ), (value) {
      if (value != null) {
        goTo(
          context: context,
          routeName: TransactionTokenPage.routeName,
          permanent: true,
          arguments: TransactionTokenPageArguments(tokenId: value.id!),
        );
      }
    }, message: "Requesting payment...");
  }
}
