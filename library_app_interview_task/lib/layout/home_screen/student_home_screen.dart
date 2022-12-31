import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/authentication/login_screen.dart';
import 'package:library_app_interview_task/layout/books/books_screen.dart';
import 'package:library_app_interview_task/layout/borrowing/borrowing_history.dart';
import 'package:library_app_interview_task/shared/local/components/custom_elevated_button.dart';
import 'package:library_app_interview_task/shared/local/components/home_app_bar.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
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
                buildElevatedButton(context, 'Browse All Books', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BooksScreen(),
                    ),
                  );
                }),
                const SizedBox(height: 20.0),
                buildElevatedButton(context, 'Show Borrowing History', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const BorrowingHistoryScreen(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
