import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/books/books_screen.dart';
import 'package:library_app_interview_task/shared/local/components/custom_elevated_button.dart';
import 'package:library_app_interview_task/shared/local/components/home_app_bar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(context),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildElevatedButton(context, 'Manage Book', () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BooksScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
