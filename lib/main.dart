import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'plant_provider.dart';
import 'plant_screen_manager.dart';

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
