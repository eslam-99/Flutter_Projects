import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/home_screen/admin_home_screen.dart';
import 'package:library_app_interview_task/layout/home_screen/staff_home_screen.dart';
import 'package:library_app_interview_task/layout/home_screen/student_home_screen.dart';
import 'package:library_app_interview_task/models/enums/users_role.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (UserProvider.instance.currentUser?.role! ?? '') {
      case UserRole.admin:
        return const AdminHomePage();
      case UserRole.staff:
        return const StaffHomePage();
      case UserRole.student:
        return const StudentHomePage();
      default:
        return Container();
    }
  }
}
