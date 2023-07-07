import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Care App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PlantListScreen(),
    );
  }
}

class PlantListScreen extends StatefulWidget {
  @override
  _PlantListScreenState createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  List<Plant> plants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Plants'),
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (ctx, index) {
          final plant = plants[index];
          return ListTile(
            title: Text(plant.name),
            subtitle: Text('Next watering: ${plant.getNextWateringDate()}'),
            onTap: () {
              _showPlantDetailsDialog(plant);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddPlantDialog();
        },
      ),
    );
  }

  void _showAddPlantDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        String plantName = '';
        int wateringDays = 7;
        return AlertDialog(
          title: Text('Add Plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  plantName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Plant Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  wateringDays = int.parse(value);
                },
                decoration: InputDecoration(
                  labelText: 'Watering Days',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  plants.add(Plant(name: plantName, wateringFrequency: Duration(days: wateringDays)));
                });
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPlantDetailsDialog(Plant plant) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(plant.name),
          content: Text('Next watering: ${plant.getNextWateringDate()}'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  plants.remove(plant);
                });
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Plant {
  String name;
  Duration wateringFrequency;
  late DateTime lastWateredDate;

  Plant({required this.name, this.wateringFrequency = const Duration(days: 7)}) {
    lastWateredDate = DateTime.now();
  }

  DateTime getNextWateringDate() {
    return lastWateredDate.add(wateringFrequency);
  }
}
