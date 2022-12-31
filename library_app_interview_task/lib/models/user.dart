import 'package:library_app_interview_task/models/enums/users_role.dart';

class User {
  String? uid;
  String? name;
  String? id;
  String? email;
  UserRole? role;

  User.fromDoc(String this.uid, Map data) {
    name = data['name'];
    id = data['id'];
    email = data['email'];
    role  = UserRole.values[int.parse(data['role'])];
  }
}