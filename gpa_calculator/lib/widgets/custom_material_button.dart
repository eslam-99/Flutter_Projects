import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final double width;
  final Color color;
  final double circularRadius;
  final IconData iconData;
  final String text;
  final double fontSize;
  final Function callback;


  CustomMaterialButton({
    @required this.width,
    @required this.color,
    @required this.circularRadius,
    @required this.iconData,
    @required this.text,
    @required this.fontSize,
    @required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularRadius),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
        onPressed: () => callback(context),
      ),
    );
  }
}
