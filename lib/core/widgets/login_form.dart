import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/users/register.dart';

class LoginForm extends StatefulWidget {
  final void Function(User luser)? setUser;
  final bool permanetGoTo;
  const LoginForm({super.key, this.setUser, this.permanetGoTo = true});

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
          Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Username')),
                keyboardType: TextInputType.name,
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
              )),
          Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(label: Text('Password')),
                  onChanged: (value) {
                    password = value;
                  })),
          Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text('Login'))),
          Container(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                  onPressed: () {
                    goTo(
                        context: context,
                        routeName: RegisterScreen.routeName,
                        permanent: widget.permanetGoTo);
                  },
                  child: const Text('Create Account'))),
        ],
      ),
    );
  }

  void _login() {
    User().login(username, password).then((value) {
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
