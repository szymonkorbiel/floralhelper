import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'plant_details_screen.dart';

class PlantsWikiScreen extends StatefulWidget {
  @override
  _PlantsWikiScreenState createState() => _PlantsWikiScreenState();
}

class _PlantsWikiScreenState extends State<PlantsWikiScreen> {
  String searchQuery = '';
  List<PlantData>? plantData;

  // Inicjalizacja SharedPreferences
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _loadSearchQuery(); // Wczytanie ostatniego wyszukiwania
  }

  // Metoda do wczytywania ostatniego wyszukiwania z SharedPreferences
  Future<void> _loadSearchQuery() async {
    _preferences = await SharedPreferences.getInstance();
    final savedQuery = _preferences.getString('searchQuery');
    if (savedQuery != null && savedQuery.isNotEmpty) {
      setState(() {
        searchQuery = savedQuery;
      });
      fetchPlantData(savedQuery);
    }
  }

  // Metoda do zapisywania aktualnego wyszukiwania do SharedPreferences
  Future<void> _saveSearchQuery(String query) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setString('searchQuery', query);
  }

  Future<void> fetchPlantData(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://trefle.io/api/v1/plants/search?token=gHFcX_ATz_V7DsmPkY-YNHOTwz4ogF0jWPqRG3Oip8I&q=$query'),
    );
    print('Response: ${response.body}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'].isNotEmpty) {
        final plantJsonList = jsonData['data'];
        final List<PlantData> resultList = [];

        for (final plantJson in plantJsonList) {
          resultList.add(PlantData.fromJson(plantJson));
        }

        setState(() {
          plantData = resultList;
        });
      } else {
        setState(() {
          plantData = null;
        });
      }
    } else {
      throw Exception('Failed to fetch plant data');
    }
  }

  Widget _buildPlantDetails() {
    if (plantData != null && plantData!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: plantData!.length,
        itemBuilder: (context, index) {
          final plant = plantData![index];
          final isEven = index % 2 == 0;
          final backgroundColor =
              isEven ? Colors.lightGreen[100] : Colors.lightGreen[500];

          return Card(
            color: backgroundColor,
            child: ListTile(
              title: Text(plant.commonName ?? 'Unknown'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantDetailsScreen(
                      plant: plant,
                      index: index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants Wiki'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Plant',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (searchQuery.isNotEmpty) {
                  fetchPlantData(searchQuery);
                  _saveSearchQuery(searchQuery); // Zapisz aktualne wyszukiwanie
                }
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            _buildPlantDetails(),
            if (plantData == null && searchQuery.isNotEmpty)
              Text('No plant found with the given search query.'),
          ],
        ),
      ),
    );
  }
}

class PlantData {
  final String? commonName;
  final String? imageUrl;
  final String? scientificName;
  final String? rank;
  final String? genus;
  final String? family;

  PlantData({
    this.commonName,
    this.imageUrl,
    this.scientificName,
    this.rank,
    this.genus,
    this.family,
  });

  factory PlantData.fromJson(Map<String, dynamic> json) {
    return PlantData(
      commonName: json['common_name'],
      imageUrl: json['image_url'],
      scientificName: json['scientific_name'] ?? 'N/A',
      rank: json['rank'],
      genus: json['genus'],
      family: json['family'],
    );
  }
}
