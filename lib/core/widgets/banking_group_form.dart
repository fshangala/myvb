import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            decoration: const InputDecoration(
                label: Text('Investment Interest'),
                helperText: 'Percentage interest, e.g 10'),
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
            decoration: const InputDecoration(
                label: Text('Loan Period'),
                helperText: 'Loan period in days e.g 30'),
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
            decoration: const InputDecoration(
                label: Text('Investment Cycle'),
                helperText: 'Investment cycle in days e.g 90'),
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
        owner: widget.user.id,
        name: groupName.text,
        investmentInterest: int.parse(groupInvestmentInterest.text),
        loanPeriod: int.parse(groupLoanPeriod.text),
        investmentCycle: int.parse(groupInvestmentCycle.text)));

    resolveFuture(context, bankingGroup.save(), (value) {
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create banking group!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${value.name} created!')));
        resolveFuture(context, value.addMember(widget.user.email!), (member) {
          if (widget.onSaved != null) {
            widget.onSaved!(value);
          }
        }, message: 'Joining ${value.name}');
      }
    }, message: 'Creating ${bankingGroup.name}');
  }
}
