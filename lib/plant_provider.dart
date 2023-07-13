import 'package:flutter/foundation.dart';

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
