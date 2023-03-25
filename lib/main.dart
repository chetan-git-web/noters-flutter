import 'package:flutter/material.dart';
import 'package:noters/Routes/Routes.dart';
import 'package:noters/services/auth/auth_service.dart';
import 'package:noters/views/login_view.dart';
import 'package:noters/views/note_view.dart';
import 'package:noters/views/registration_view.dart';
import 'package:noters/views/Verifyemail_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    home: const Home(),
    routes: {
      loginview: (context) => const LoginView(),
      registerview: (context) => const RegistrationView(),
      homeview: (context) => const Home(),
      mainview: (context) => const MainView(),
      verifyemailview: (context) => const VerifyEmail(),
    },
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

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
