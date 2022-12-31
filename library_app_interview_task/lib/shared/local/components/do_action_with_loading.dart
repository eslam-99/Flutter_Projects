import 'package:flutter/material.dart';
import 'package:library_app_interview_task/shared/local/components/loading_widget.dart';

Future<void> doActionWithLoading(BuildContext context, Function action, {String? successMsg}) async {
  LoadingWidget().loading(context);
  try {
    await action();
    if (successMsg != null) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(successMsg),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        //
      }
    }
    Navigator.of(context).pop();
  } catch (e) {
    Navigator.of(context).pop();
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (e) {
      //
    }
  }
}