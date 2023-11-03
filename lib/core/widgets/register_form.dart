import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/users/login.dart';

class RegisterForm extends StatefulWidget {
  final void Function(User user)? setUser;
  const RegisterForm({super.key, this.setUser});

  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController(text: '');
  var firstNameController = TextEditingController(text: '');
  var lastNameController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Username')),
                controller: usernameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == '') {
                    return 'Username cannot be empty!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(label: Text('First name')),
                controller: firstNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == '') {
                    return 'First name cannot be empty!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Last name')),
                controller: lastNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == '') {
                    return 'Last name cannot be empty!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Password')),
                controller: passwordController,
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                    child: const Text('Register'))),
            Container(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: const Text('Already have an account? Login'))),
          ],
        ));
  }

  void _register() {
    var newUser = User().create(UserModelArguments(
        username: usernameController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        password: passwordController.text));
    newUser.save().then((value) {
      if (value != null) {
        newUser = value;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account ${value.username} created!')));
        Navigator.pop(context);
        Navigator.pushNamed(context, LoginScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not create account!')));
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not create account! $error')));
    });
  }
}
