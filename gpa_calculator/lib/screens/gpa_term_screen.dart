import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../widgets/custom_material_button.dart';
import 'result_screen.dart';

class GpaForTerm extends StatelessWidget {
  final courses = List<int>.generate(7, (index) => index + 1);
  final List gpaGrades = [
    {"grade": "F", "gpa": 0.0},
    {"grade": "D", "gpa": 2.0},
    {"grade": "D+", "gpa": 2.2},
    {"grade": "C", "gpa": 2.4},
    {"grade": "C+", "gpa": 2.7},
    {"grade": "B", "gpa": 3.0},
    {"grade": "B+", "gpa": 3.3},
    {"grade": "A", "gpa": 3.7},
    {"grade": "A+", "gpa": 4.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Courses Count :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                buildCoursesCountDDB(context),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0;
                    i < context.watch<DataProvider>().coursesCount;
                    i++)
                  buildCourseData(context, i),
                buildCalcButton(context),
                SizedBox(height: 2.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownButton<int> buildCoursesCountDDB(BuildContext context) {
    return DropdownButton(
      value: context.watch<DataProvider>().coursesCount,
      style: TextStyle(color: Colors.white),
      dropdownColor: Theme.of(context).accentColor,
      items: courses.map((val) {
        return DropdownMenuItem(
          child: Text("$val"),
          value: val,
        );
      }).toList(),
      onChanged: (val) {
        context.read<DataProvider>().coursesCount = val;
      },
    );
  }

  Container buildCourseData(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Center(child: Text("Course #${index + 1}")),
          Divider(
            thickness: 1.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Grade"),
              Row(
                children: [
                  DropdownButton(
                    value: context.watch<DataProvider>().coursesGpa[index],
                    items: gpaGrades.map((grade) {
                      return DropdownMenuItem(
                        value: grade["gpa"],
                        child: Text("${grade["grade"]}\t\t${grade["gpa"]}"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      context.read<DataProvider>().coursesGpaSet(index, val);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row buildCalcButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomMaterialButton(
          width: MediaQuery.of(context).size.width * 0.4,
          color: Theme.of(context).accentColor,
          circularRadius: 25.0,
          iconData: Icons.assessment,
          text: "Calculate",
          fontSize: 16.0,
          callback: calcGpa,
        ),
      ],
    );
  }

  void calcGpa(BuildContext context) {
    double result = 0;
    for (int i = 0; i < context.read<DataProvider>().coursesCount; i++) {
      result += context.read<DataProvider>().coursesGpa[i];
    }
    result /= context.read<DataProvider>().coursesCount;
    String str = result.toStringAsFixed(2);
    context.read<DataProvider>().gpa[0] = double.parse(str[0]);
    context.read<DataProvider>().gpa[1] = double.parse(str[2]);
    context.read<DataProvider>().gpa[2] = double.parse(str[3]);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Result(result, true);
    }));
  }
}
