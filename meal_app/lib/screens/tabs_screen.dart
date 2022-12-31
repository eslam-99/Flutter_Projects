import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import '../widgets/main_drawer.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;
  TabsScreen(this.favoriteMeals);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  List<Map<String, Object>> _pages;
  int selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page' : CategoriesScreen(),
        'title' : "Categories"
      },
      {
        'page' : FavoritesScreen(widget.favoriteMeals),
        'title' : "Your Favorites",
      },
    ];
    super.initState();
  }
  void _selectedPage(int value){
    setState(() {
      selectedPageIndex = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pages[selectedPageIndex]['title']),),
      body: _pages[selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.white,
        currentIndex: selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
          ),
        ],
      ),
      drawer: MainDrawer(),
    );
  }
}
