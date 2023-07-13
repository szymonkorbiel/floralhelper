import 'package:flutter/material.dart';
import 'plants_wiki_screen.dart';

class PlantDetailsScreen extends StatelessWidget {
  final PlantData plant;
  final int index;

  PlantDetailsScreen({required this.plant, required this.index});

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    final backgroundColor =
        isEven ? Colors.lightGreen[100] : Colors.lightGreen[500];

    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Details'),
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (plant.imageUrl != null)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(plant.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Common Name: ${plant.commonName ?? 'N/A'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Scientific Name: ${plant.scientificName ?? 'N/A'}'),
                        SizedBox(height: 8),
                        Text('Rank: ${plant.rank ?? 'N/A'}'),
                        SizedBox(height: 8),
                        Text('Genus: ${plant.genus ?? 'N/A'}'),
                        SizedBox(height: 8),
                        Text('Family: ${plant.family ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
