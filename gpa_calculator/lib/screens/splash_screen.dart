import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/theme_provider.dart';

class SplashScreen extends StatelessWidget {

  Future initTheme(BuildContext context) async {
    // if (!isInitiated) {
    //   isInitiated = true;
      await Provider.of<ThemeProvider>(context).setTheme().then((value) {
        // Timer(Duration(seconds: 1), () {
        //   loadingTimer.cancel();
          startApp(context);
        // });
      });
    // }
  }

  void startApp(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return MyApp();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    // if (loadingTimer == null)
    //   loadingTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
    //     setState(() {
    //       if (dots.length == 0)
    //         dots = ".";
    //       else if (dots.length == 1)
    //         dots = "..";
    //       else if (dots.length == 2)
    //         dots = "...";
    //       else if (dots.length == 3) dots = "";
    //     });
    //   });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      home: Scaffold(
        // backgroundColor: Color.fromRGBO(48, 48, 48, 1.0),
        body: Builder(
          builder: (context) => FutureBuilder(
            future: initTheme(context),
            builder: (context, snapshot) {
              return
                  Container();
                  // Container(
                // width: double.infinity,
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CircularProgressIndicator(
                //       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                //     ),
                //     SizedBox(height: 20),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           dots,
                //           style: TextStyle(
                //             color: Color.fromRGBO(48, 48, 48, 1.0),
                //             fontSize: 25,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         Text(
                //           "Loading",
                //           style: TextStyle(
                //             color: Colors.blue,
                //             fontSize: 25,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         Text(
                //           dots,
                //           style: TextStyle(
                //             color: Colors.blue,
                //             fontSize: 25,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
