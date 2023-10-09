import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';

class LoginForm extends StatefulWidget {
  final void Function(User luser)? setUser;
  const LoginForm({super.key, this.setUser});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Username', label: Text('Username')),
            onChanged: (value) {
              username = value;
            },
            validator: (value) {
              if (value == '') {
                return 'Please enter some value';
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text('Password')),
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _login();
                }
              },
              child: const Text('Login')),
        ],
      ),
    );
  }

  void _login() {
    User.login(username, password).then((value) {
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Welcome ${value.username}')));
        if (widget.setUser != null) {
          widget.setUser!(value);
        }
      }
    });
  }
}
