import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/users/login.dart';

class RegisterForm extends StatefulWidget {
  final String? userId;
  final void Function(User user)? setUser;
  const RegisterForm({super.key, this.userId, this.setUser});

  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  User newUser = User(username: '', firstName: '', lastName: '');

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      User.getByid(widget.userId!).then((value) {
        if (value != null) {
          newUser = value;
        }
      });
    }
  }

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
                initialValue: newUser.username,
                onChanged: (value) {
                  newUser.username = value;
                },
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
                initialValue: newUser.firstName,
                onChanged: (value) {
                  newUser.firstName = value;
                },
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
                initialValue: newUser.lastName,
                onChanged: (value) {
                  newUser.lastName = value;
                },
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
                onChanged: (value) {
                  newUser.password = value;
                },
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
