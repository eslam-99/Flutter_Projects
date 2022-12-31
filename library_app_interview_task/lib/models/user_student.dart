import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/models/user.dart';

class StudentUser extends User {
  StudentUser.fromDoc(super.uid, super.data) : super.fromDoc();

  void borrowBook(Book book) {

  }

  void returnBook(Book book) {

  }
}