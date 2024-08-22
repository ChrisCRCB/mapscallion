import 'package:backstreets_widgets/screens.dart';
import 'package:dart_overpass/dart_overpass.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:geolocator/geolocator.dart';

import '../widgets/pages/nearby_page.dart';
import '../widgets/pages/position_page.dart';

/// The main screen of the application.
class MainScreen extends StatefulWidget {
  /// Create an instance.
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// The current position.
  Position? _position;

  /// The current nearby elements.
  List<Element>? _elements;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Nearby',
            icon: const Icon(Icons.location_on),
            builder: (final _) => NearbyPage(
              updatePosition: (final position) => _position = position,
              updateElements: (final elements) => _elements = elements,
              initialPosition: _position,
              initialElements: _elements,
            ),
          ),
          TabbedScaffoldTab(
            title: 'GPS Information',
            icon: const Icon(Icons.info),
            builder: (final _) => PositionPage(
              updatePosition: (final position) => _position = position,
              initialPosition: _position,
            ),
          ),
        ],
      );
}
