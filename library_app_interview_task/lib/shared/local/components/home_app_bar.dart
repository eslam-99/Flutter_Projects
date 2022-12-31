import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/authentication/login_screen.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

PreferredSizeWidget buildHomeAppBar(BuildContext context) {
  return AppBar(
    title: Text('Hello ${UserProvider.instance.currentUser!.name}'),
    actions: [
      ElevatedButton.icon(
        onPressed: () async {
          try {
            await FirebaseProvider.instance.logout();
            while (Navigator.canPop(context)) Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return LoginScreen();
              }),
            );
          } catch (e) {
            //
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
      )
    ],
  );
}