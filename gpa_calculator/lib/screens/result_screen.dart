import 'package:flutter/material.dart';

import '../widgets/custom_material_button.dart';
import 'home_page.dart';

class Result extends StatelessWidget {
  final double result;
  final bool calcTotal;

  Result(this.result, this.calcTotal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your GPA is\n${result.toStringAsFixed(2)}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.0),
            buildButtons(context),
          ],
        ),
      ),
    );
  }

  Row buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (calcTotal)
        CustomMaterialButton(
          width: MediaQuery.of(context).size.width * 0.4,
          color: Theme.of(context).accentColor,
          circularRadius: 25.0,
          iconData: Icons.assessment,
          text: "Cumulative",
          fontSize: 16.0,
          callback: (BuildContext context) {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) {
              return HomePage(
                initIndex: 1,
              );
            }));
          },
        ),
        CustomMaterialButton(
          width: MediaQuery.of(context).size.width * 0.4,
          color: Theme.of(context).accentColor,
          circularRadius: 25.0,
          iconData: Icons.assignment_turned_in,
          text: "OK",
          fontSize: 16.0,
          callback: (BuildContext context) {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
