import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import 'gpa_cumulative_screen.dart';
import 'gpa_term_screen.dart';

class HomePage extends StatefulWidget {
  final int initIndex;

  HomePage({this.initIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text("GPA Calculator"),
          actions: buildAppBarActions(context),
          bottom: buildTabBar(),
        ),
        body: TabBarView(
          children: [
            GpaForTerm(),
            TotalGpa(),
          ],
        ),
      ),
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      tabs: [
        Tab(
          text: "Term GPA",
        ),
        Tab(
          text: "Cumulative GPA",
        ),
      ],
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        padding: context.watch<ThemeProvider>().isDark
            ? EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0)
            : EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.white),
          // border: Border.all(color: Theme.of(context).accentColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (context.watch<ThemeProvider>().isDark)
              Center(
                child: Icon(Icons.brightness_3),
              ),
            Switch(
              value: context.watch<ThemeProvider>().isDark,
              activeColor: Colors.grey,
              onChanged: context.read<ThemeProvider>().switchTheme,
            ),
            if (!context.watch<ThemeProvider>().isDark)
              Center(
                child: Icon(Icons.brightness_6_rounded),
              ),
          ],
        ),
      ),
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.info_outline_rounded),
          onPressed: () => buildInfoDialog(context),
        ),
      ),
    ];
  }

  Future buildInfoDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("GPA Calculator", textAlign: TextAlign.center),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "How to use:\n",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "In 'Term GPA' tap you can choose the number of your "
                          "courses for the current term and choose GPA for "
                          "each course to calculate the GPA.\n\n"
                          "In 'Cumulative GPA' tap you can calculate your "
                          "previous GPA with the current one by choosing the "
                          "number of finished courses and the old GPA then do the"
                          " same to the current term.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text("By: Eslam Mohamed"),
                      SizedBox(height: 5.0),
                      Text("FCAI"),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Text(
                          "OK",
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
