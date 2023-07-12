import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlantProvider(),
      child: MaterialApp(
        title: 'Plant Care App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: PlantScreenManager(),
      ),
    );
  }
}

class PlantProvider with ChangeNotifier {
  List<Plant> _plants = [];

  List<Plant> get plants => _plants;

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  void removePlant(Plant plant) {
    _plants.remove(plant);
    notifyListeners();
  }

  String? getBackgroundImageUrl(String plantName) {
    final plant = _plants.firstWhere((p) => p.name == plantName, orElse: () => Plant(name: '', wateringFrequency: Duration(days: 7), backgroundImageUrl: 'assets/images/background.jpg'));
    return plant.backgroundImageUrl;
  }
}

class PlantScreenManager extends StatefulWidget {
  @override
  _PlantScreenManagerState createState() => _PlantScreenManagerState();
}

class _PlantScreenManagerState extends State<PlantScreenManager> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PlantListScreen(),
    PlantWikiScreen(),
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

class PlantListScreen extends StatelessWidget {
  final Map<String, String> plantImages = {
    'Paproc': 'assets/images/paproc.jpg',
    'Inna roślina': 'assets/images/inna_roslinka.jpg',
    // Dodaj inne nazwy roślin i odpowiadające im adresy URL obrazków
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

        return AlertDialog(
          title: Text(plant.name),
          content: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(plant.backgroundImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.7),
              ),
              Text(
                'Next watering: $nextWateringDate',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final plantProvider = Provider.of<PlantProvider>(context, listen: false);
                plantProvider.removePlant(plant);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class PlantWikiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants Wiki'),
      ),
      body: Center(
        child: Text('This is the Plants Wiki screen'),
      ),
    );
  }
}

class Plant {
  String name;
  Duration wateringFrequency;
  late DateTime lastWateredDate;
  String backgroundImageUrl;

  Plant({
    required this.name,
    this.wateringFrequency = const Duration(days: 7),
    required this.backgroundImageUrl,
  }) {
    lastWateredDate = DateTime.now();
  }

  DateTime getNextWateringDate() {
    final nextWateringDateTime = lastWateredDate.add(wateringFrequency);
    final nextWateringDate = DateTime(nextWateringDateTime.year, nextWateringDateTime.month, nextWateringDateTime.day);
    return nextWateringDate;
  }
}
