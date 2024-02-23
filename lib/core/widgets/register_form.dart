import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/home/home.dart';
import 'package:myvb/users/login.dart';

class RegisterForm extends StatefulWidget {
  final void Function(dynamic user)? setUser;
  const RegisterForm({super.key, this.setUser});

  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  var appUser = AppUser();
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(text: '');
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
                decoration: const InputDecoration(label: Text('E-mail')),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
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
    resolveFuture(
        context,
        appUser.registerUser(
            email: emailController.text,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            password: passwordController.text), (value) {
      goTo(context: context, routeName: HomeScreen.routeName, permanent: true);
    });
  }
}
