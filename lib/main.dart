import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noters/Routes/Routes.dart';
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
      loginview: (context) => const LoginView(),
      registerview: (context) => const RegistrationView(),
      homeview: (context) => const Home(),
      mainview: (context) => const MainView()
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

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

enum Menuaction { logout }

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Ui"),
        actions: [
          PopupMenuButton<Menuaction>(
            onSelected: (value) async {
              switch (value) {
                case Menuaction.logout:
                  // TODO: Handle this case.
                  final shouldlogout = await showLogOutDialog(context);
                  if (shouldlogout == true) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginview, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                // ignore: prefer_const_constructors
                PopupMenuItem<Menuaction>(
                    value: Menuaction.logout, child: Text("Log Out"))
              ];
            },
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Signout"),
          content: const Text("Do you realy want to logout"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Logout"))
          ],
        );
      })).then((value) => value ?? false);
}
