import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noters/login.dart';
import 'package:noters/registration.dart';
import 'package:noters/Verifyemail.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    home: const Home(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegistrationView(),
      '/home/': (context) => const Home()
    },
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print("email verified");
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

            return const Text("Done");
          // if (user?.emailVerified ?? false) {
          //   print("verified user");
          // } else {
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const _VerifyEmail(),
          //   ));
          // }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
