import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import 'src/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

/// The top-level app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    SoLoud.instance.init();
    // Force web accessibility.
    RendererBinding.instance.ensureSemantics();
    return MaterialApp(
      title: 'Mapscallion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
