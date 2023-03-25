import 'package:flutter/material.dart';
import 'package:noters/services/auth/auth_service.dart';
import '../Routes/Routes.dart';
import '../enums/menu_action.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

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
                  final shouldlogout = await showLogOutDialog(context);
                  if (shouldlogout == true) {
                    await AuthService.firebase().logoutUser();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginview, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
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
