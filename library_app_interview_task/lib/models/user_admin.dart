import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/models/user.dart';

class AdminUser extends User {
  AdminUser.fromDoc(super.uid, super.data) : super.fromDoc();

  void addBook(Book book) {

  }

  void deleteBook(Book book) {

  }
}