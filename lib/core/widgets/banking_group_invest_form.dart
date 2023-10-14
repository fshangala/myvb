import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/user.dart';

class BankingGroupInvestForm extends StatefulWidget {
  final User user;
  final BankingGroup bankingGroup;
  const BankingGroupInvestForm(
      {super.key, required this.user, required this.bankingGroup});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupInvestFormState();
  }
}

class _BankingGroupInvestFormState extends State<BankingGroupInvestForm> {
  final _formkey = GlobalKey<FormState>();
  var investmentAmount = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration:
                      const InputDecoration(label: Text('Investment Amount')),
                  controller: investmentAmount,
                )),
            Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('Invest'),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _invest();
                    }
                  },
                ))
          ],
        ));
  }

  dynamic _invest() {
    //widget.bankingGroup.
  }
}
