import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_plants_screen.dart';
import 'plants_wiki_screen.dart';
import 'plant_provider.dart';

class PlantScreenManager extends StatefulWidget {
  @override
  _PlantScreenManagerState createState() => _PlantScreenManagerState();
}

class _PlantScreenManagerState extends State<PlantScreenManager> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MyPlantsScreen(),
    PlantsWikiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Plants Wiki',
          ),
        ],
      ),
    );
  }
}
