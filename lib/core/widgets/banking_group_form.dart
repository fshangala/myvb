import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/functions/resolve_future.dart';

class BankingGroupForm extends StatefulWidget {
  final User user;
  final void Function(VBGroup bankingGroup)? onSaved;
  const BankingGroupForm({super.key, required this.user, this.onSaved});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupFormState();
  }
}

class _BankingGroupFormState extends State<BankingGroupForm> {
  final _formKey = GlobalKey<FormState>();
  var groupName = TextEditingController(text: '');
  var groupInvestmentInterest = TextEditingController(text: '');
  var groupLoanPeriod = TextEditingController(text: '');
  var groupInvestmentCycle = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            decoration: const InputDecoration(label: Text('Name')),
            controller: groupName,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == '') {
                return 'Name cannot be empty!';
              }
              return null;
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            decoration:
                const InputDecoration(label: Text('Investment Interest')),
            controller: groupInvestmentInterest,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == '') {
                return 'Investment Interest cannot be empty!';
              }
              return null;
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            decoration: const InputDecoration(label: Text('Loan Period')),
            controller: groupLoanPeriod,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == '') {
                return 'Loan Period cannot be empty!';
              }
              return null;
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            decoration: const InputDecoration(label: Text('Investment Cycle')),
            controller: groupInvestmentCycle,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == '') {
                return 'Investment Cycle cannot be empty!';
              }
              return null;
            },
          ),
        ),
        Container(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createBankingGroup();
                  }
                },
                child: const Text('Create Banking Group'))),
      ]),
    );
  }

  void _createBankingGroup() {
    var bankingGroup = VBGroup().create(VBGroupModelArguments(
        owner: widget.user.uid,
        name: groupName.text,
        investmentInterest: double.parse(groupInvestmentInterest.text),
        loanPeriod: int.parse(groupLoanPeriod.text),
        investmentCycle: int.parse(groupInvestmentCycle.text)));

    bankingGroup.save().then((value) {
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create banking group!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${value.name} created!')));
        resolveFuture(context, value.joinGroup(widget.user), (member) {
          if (widget.onSaved != null) {
            widget.onSaved!(value);
          }
        });
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $error')));
    });
  }
}
