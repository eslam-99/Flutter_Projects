import 'package:flutter/foundation.dart';

class DataProvider with ChangeNotifier {
  List _coursesGpa = [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0];
  List _oldGpa = [0, 0, 0];
  List _gpa = [0, 0, 0];
  int _oldCoursesCount = 1;
  int _coursesCount = 1;

  List get coursesGpa => _coursesGpa;

  void coursesGpaSet(int index, double value) {
    _coursesGpa[index] = value;
    notifyListeners();
  }

  List get oldGpa => _oldGpa;

  void oldGpaSet(int index, int value) {
    _oldGpa[index] = value;
    notifyListeners();
  }

  int get coursesCount => _coursesCount;

  set coursesCount(int value) {
    _coursesCount = value;
    notifyListeners();
  }

  int get oldCoursesCount => _oldCoursesCount;

  set oldCoursesCount(int value) {
    _oldCoursesCount = value;
    notifyListeners();
  }

  List get gpa => _gpa;

  void gpaSet(int index, int value) {
    _gpa[index] = value;
    notifyListeners();
  }
}
