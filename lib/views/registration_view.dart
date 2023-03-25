import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

import 'package:noters/Routes/Routes.dart';
import 'package:noters/errorhandling.dart';
import 'package:noters/services/auth/auth_exception.dart';
import 'package:noters/services/auth/auth_service.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewstate();
}

class _RegistrationViewstate extends State<RegistrationView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: Column(
        children: [
          const Text("Enter Email"),
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: "xyz@gmail.com"),
          ),
          const Text("Enter password"),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Abcd@123"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyemailview);
              } on WeakPasswordAuthException {
                showErrorDialogue(
                  context,
                  'weak password',
                );
              } on EmailAlreadyInUseAuthException {
                showErrorDialogue(
                  context,
                  'email already in use',
                );
              } on EmailInvalidAuthException {
                showErrorDialogue(
                  context,
                  'invalid email',
                );
              } on GenericAuthException {
                showErrorDialogue(
                  context,
                  'failed to register',
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(homeview, (route) => false);
              },
              child: const Text("Go back to login!"))
        ],
      ),
    );
  }
}
