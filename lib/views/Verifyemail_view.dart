import 'package:flutter/material.dart';
import 'package:noters/Routes/Routes.dart';
import 'package:noters/services/auth/auth_service.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify your email"),
      ),
      body: Column(
        children: [
          const Text("First check your email before clicking in this button"),
          const Text("Click Here if email not send"),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().currentUser;
              },
              child: const Text("Send Verification code")),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logoutUser();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerview, (route) => false);
              },
              child: const Text("Restart"))
        ],
      ),
    );
  }
}
