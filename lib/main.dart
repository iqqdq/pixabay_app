import 'package:flutter/material.dart';
import 'package:pixabay_test_app/ui/screens/gallery/gallery_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      home: GalleryScreen(),
    );
  }
}
