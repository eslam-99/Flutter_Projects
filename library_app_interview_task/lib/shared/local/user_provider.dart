import 'package:library_app_interview_task/models/user.dart';

class UserProvider {
  UserProvider._privateConstructor();
  static final UserProvider instance = UserProvider._privateConstructor();

  User? currentUser;

  setUser(user) {
    currentUser = user;
  }
}