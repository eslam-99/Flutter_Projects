import 'package:flutter/material.dart';
import '../widgets/meal_item.dart';
import '../models/meal.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;
  FavoritesScreen(this.favoriteMeals);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    if(widget.favoriteMeals.isEmpty){
      return Center(
        child: Text("You have no favorites yet!- Starting adding some"),
      );
    }
    else{
      return ListView.builder(
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: (){
              setState(() {
                changed = !changed;
              });
            },
            child: MealItem(
              id: widget.favoriteMeals[index].id,
              imageUrl: widget.favoriteMeals[index].imageUrl,
              title: widget.favoriteMeals[index].title,
              duration: widget.favoriteMeals[index].duration,
              affordability: widget.favoriteMeals[index].affordability,
              complexity: widget.favoriteMeals[index].complexity,
            ),
          );
        },
        itemCount: widget.favoriteMeals.length,
      );
    }

  }
}
