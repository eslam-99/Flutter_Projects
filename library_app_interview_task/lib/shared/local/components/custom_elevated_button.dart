import 'package:flutter/material.dart';

Flexible buildElevatedButton(
    BuildContext context, String label, void Function() callback) {
  return Flexible(
    child: ElevatedButton(
      onPressed: callback,
      child: SizedBox(
        width: 400.0,
        height: 100.0,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
  );
}