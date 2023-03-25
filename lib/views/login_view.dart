import 'package:flutter/material.dart';
import 'package:noters/Routes/Routes.dart';
import 'package:noters/services/auth/auth_exception.dart';
import 'package:noters/services/auth/auth_service.dart';

import '../errorhandling.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewstate();
}

class _LoginViewstate extends State<LoginView> {
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          const Text("Enter Email"),
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "xyz@gmail.com",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
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
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    mainview,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyemailview,
                    (route) => false,
                  );
                }

                // ignore: use_build_context_synchronously
              } on UserNotFoundAuthException {
                await showErrorDialogue(
                  context,
                  'user not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialogue(
                  context,
                  'wrong credentials',
                );
              } on GenericAuthException {
                await showErrorDialogue(context, 'authenrication error');
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerview, (route) => false);
              },
              child: const Text("Not registered yet? Clik Here!"))
        ],
      ),
    );
  }
}
