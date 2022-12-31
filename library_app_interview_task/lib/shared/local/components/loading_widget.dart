import 'package:flutter/material.dart';

class LoadingWidget {
  Future loading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const Center(
            child: Material(
              color: Colors.transparent,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}
