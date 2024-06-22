import 'package:app_ml/Face_Detection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App_ML());
}

class App_ML extends StatelessWidget {
  const App_ML({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Face_Detection(),
    );
  }
}
