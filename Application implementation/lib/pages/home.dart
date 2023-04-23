import 'package:flutter/material.dart';
import 'package:food_app/pages/index.dart';

///首页
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Widget> pages = const [SearchPage(), FavoritePage(), PlanPage()];
  List<Widget> pages = const [SearchPage(), IngredientPage(), PlanPage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_food_beverage_outlined), label: "Ingredient"),
          BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye_outlined), label: "Plan"),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      // body: pages[currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }
}
