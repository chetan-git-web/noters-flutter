import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

import 'package:noters/Routes/Routes.dart';
import 'package:noters/errorhandling.dart';

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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                Navigator.of(context).pushNamed(verifyemailview);
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showErrorDialogue(context, e.toString());
                } else if (e.code == 'email-already-in-use') {
                  showErrorDialogue(context, e.toString());
                } else if (e.code == 'invalid-email') {
                  showErrorDialogue(context, e.toString());
                } else {
                  showErrorDialogue(context, e.toString());
                }
              } catch (e) {
                showErrorDialogue(context, e.toString());
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
