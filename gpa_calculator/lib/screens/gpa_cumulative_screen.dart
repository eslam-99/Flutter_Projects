import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../widgets/custom_material_button.dart';
import 'result_screen.dart';

class TotalGpa extends StatelessWidget {
  final oldCourses = List<int>.generate(48, (index) => index + 1);
  final currentCourses = List<int>.generate(7, (index) => index + 1);
  final gpa1 = List<int>.generate(5, (index) => index);
  final gpa2 = List<int>.generate(10, (index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 2; i++) buildInfoContainer(i, context),
              buildCalcButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Container buildInfoContainer(int i, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Center(child: i == 0 ? Text("Old GPA") : Text("Current GPA")),
          Divider(
            thickness: 1.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("GPA"),
              buildGpaSelector(i, context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Courses Count"),
              i == 0
                  ? buildOldCoursesCountDDB(context)
                  : buildCoursesCountDDB(context),
            ],
          ),
        ],
      ),
    );
  }

  DropdownButton<int> buildOldCoursesCountDDB(BuildContext context) {
    return DropdownButton(
      value: context.watch<DataProvider>().oldCoursesCount,
      items: oldCourses.map((val) {
        return DropdownMenuItem(
          child: Text("$val"),
          value: val,
        );
      }).toList(),
      onChanged: (val) {
        context.read<DataProvider>().oldCoursesCount = val;
      },
    );
  }

  DropdownButton<int> buildCoursesCountDDB(BuildContext context) {
    return DropdownButton(
      value: context.watch<DataProvider>().coursesCount,
      items: currentCourses.map((val) {
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

  Row buildGpaSelector(int i, BuildContext context) {
    return Row(
      children: [
        createDropDown(context, i, 0, gpa1),
        Text("."),
        (i == 0 && context.watch<DataProvider>().oldGpa[0] == 4)
            ? Row(
                children: [
                  createDropDown(context, i, 1, [0]),
                  createDropDown(context, i, 2, [0])
                ],
              )
            : (i == 1 && context.watch<DataProvider>().gpa[0] == 4)
                ? Row(
                    children: [
                      createDropDown(context, i, 1, [0]),
                      createDropDown(context, i, 2, [0])
                    ],
                  )
                : Row(
                    children: [
                      createDropDown(context, i, 1, gpa2),
                      createDropDown(context, i, 2, gpa2)
                    ],
                  ),
      ],
    );
  }

  Widget createDropDown(BuildContext context, int i, int j, List gpaList) {
    return Container(
      margin: EdgeInsets.all(3),
      height: 50,
      width: 50,
      child: DropdownButton(
        isExpanded: true,
        value: i == 0
            ? context.watch<DataProvider>().oldGpa[j]
            : context.watch<DataProvider>().gpa[j],
        items: gpaList.map((val) {
          return DropdownMenuItem(
            child: Text("$val"),
            value: val,
          );
        }).toList(),
        onChanged: (val) {
          // setState(() {
          if (i == 0) {
            if (j == 0 && val == 4) {
              context.read<DataProvider>().oldGpaSet(1, 0);
              context.read<DataProvider>().oldGpaSet(2, 0);
            }
            context.read<DataProvider>().oldGpaSet(j, val);
          } else {
            if (j == 0 && val == 4) {
              context.read<DataProvider>().gpaSet(1, 0);
              context.read<DataProvider>().gpaSet(2, 0);
            }
            context.read<DataProvider>().gpaSet(j, val);
          }
          // });
        },
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
    double result = (context.read<DataProvider>().oldGpa[0] +
                context.read<DataProvider>().oldGpa[1] / 10 +
                context.read<DataProvider>().oldGpa[2] / 100) *
            context.read<DataProvider>().oldCoursesCount +
        (context.read<DataProvider>().gpa[0] +
                context.read<DataProvider>().gpa[1] / 10 +
                context.read<DataProvider>().gpa[2] / 100) *
            context.read<DataProvider>().coursesCount;
    result /= (context.read<DataProvider>().oldCoursesCount +
        context.read<DataProvider>().coursesCount);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Result(result, false);
    }));
  }
}
