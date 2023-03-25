import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;
import 'package:noters/Routes/Routes.dart';

import 'errorhandling.dart';

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
                final usercredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  mainview,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  showErrorDialogue(context, e.toString());
                } else if (e.code == "wrong-password") {
                  showErrorDialogue(context, e.toString());
                } else {
                  showErrorDialogue(context, e.toString());
                }
              } catch (e) {
                showErrorDialogue(context, e.toString());
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
