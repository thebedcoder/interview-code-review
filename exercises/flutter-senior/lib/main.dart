import 'package:flutter/material.dart';
import 'package:habitat/src/core/di/di_initializer.dart';
import 'package:habitat/src/features/listings/presentation/pages/listings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
  runApp(const HabitatApp());
}

class HabitatApp extends StatelessWidget {
  const HabitatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ListingsPage(),
    );
  }
}
