import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/borrowing/manage_requests.dart';
import 'package:library_app_interview_task/models/enums/borrow_status.dart';
import 'package:library_app_interview_task/shared/local/components/custom_elevated_button.dart';
import 'package:library_app_interview_task/shared/local/components/home_app_bar.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key? key}) : super(key: key);

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
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
                buildElevatedButton(context, 'Manage Borrowing Requests', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ManageBorrowingRequestsScreen(status: BorrowStatus.borrowRequested)),
                  );
                }),
                const SizedBox(height: 20.0),
                buildElevatedButton(context, 'Manage Returning Requests', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ManageBorrowingRequestsScreen(status: BorrowStatus.returnRequested)),
                  );
                }),
                // buildElevatedButton(context, 'Delete A Book', () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
