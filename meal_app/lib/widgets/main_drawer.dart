import 'package:flutter/material.dart';
import '../screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function func){
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'RobotoCondensed',
      ),),
      onTap: func,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).colorScheme.secondary,
            child: Text("Cooking Up!", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).primaryColor,

            ),),
          ),
          SizedBox(height: 20,),
          buildListTile("Meal", Icons.restaurant, (){Navigator.of(context).pushReplacementNamed('/');}),
          buildListTile("Filters", Icons.settings, (){Navigator.of(context).pushReplacementNamed(FiltersScreen.routName);}),
        ],
      ),
    );
  }
}
