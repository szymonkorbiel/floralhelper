import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'plant_provider.dart';


class MyPlantsScreen extends StatelessWidget {
  final Map<String, String> plantImages = {
    'Paproć': 'assets/images/paproc.jpg',
    'Trawa': 'assets/images/inna_roslinka.jpg',

  };

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Plants'),
      ),
      body: ListView.builder(
        itemCount: plantProvider.plants.length,
        itemBuilder: (ctx, index) {
          final plant = plantProvider.plants[index];
          final intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd');
          final String nextWateringDate = dateFormat.format(plant.getNextWateringDate());
          final backgroundImageUrl = plantProvider.getBackgroundImageUrl(plant.name);

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImageUrl ?? 'assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
                ListTile(
                  title: Text(
                    plant.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Next watering: $nextWateringDate',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _showPlantDetailsDialog(context, plant);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddPlantDialog(context);
        },
      ),
    );
  }

  void _showAddPlantDialog(BuildContext context) {
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
                final plantProvider = Provider.of<PlantProvider>(context, listen: false);
                String? imageUrl = plantImages[plantName];
                if (imageUrl != null) {
                  plantProvider.addPlant(
                    Plant(
                      name: plantName,
                      wateringFrequency: Duration(days: wateringDays),
                      backgroundImageUrl: imageUrl,
                    ),
                  );
                } else {
                  plantProvider.addPlant(
                    Plant(
                      name: plantName,
                      wateringFrequency: Duration(days: wateringDays),
                      backgroundImageUrl: 'assets/images/background.jpg',
                    ),
                  );
                }
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

 void _showPlantDetailsDialog(BuildContext context, Plant plant) {
  showDialog(
    context: context,
    builder: (ctx) {
      final intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd');
      final String nextWateringDate = dateFormat.format(plant.getNextWateringDate());

      return Dialog(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Next watering: $nextWateringDate',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(plant.backgroundImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
                      plantProvider.removePlant(plant);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
