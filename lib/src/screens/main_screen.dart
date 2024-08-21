import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_overpass/dart_overpass.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:geolocator/geolocator.dart';

import '../widgets/elements_list_view.dart';
import '../widgets/timed_location_builder.dart';

/// The main screen of the application.
class MainScreen extends StatefulWidget {
  /// Create an instance.
  const MainScreen({
    this.searchRadius = 500.0,
    this.searchDistanceThreshold = 400.0,
    super.key,
  });

  /// The search radius for nearby nodes.
  final double searchRadius;

  /// How many metres the user must travel before a new node search is
  /// performed.
  final double searchDistanceThreshold;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// The overpass API to use.
  late final DartOverpass _overpass;

  /// The last position used.
  Position? _lastPosition;

  /// The elements which have been loaded.
  List<Element>? _elements;

  /// The last position where nodes were searched.
  Position? _lastSearchedPosition;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _overpass = DartOverpass(dio: Dio());
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SimpleScaffold(
        title: 'Location',
        actions: [
          ElevatedButton(
            onPressed: () => setState(() {
              _elements = [];
              _lastPosition = null;
              _lastSearchedPosition = null;
            }),
            child: const Icon(
              Icons.refresh,
              semanticLabel: 'Refresh',
            ),
          ),
        ],
        body: TimedLocationBuilder(
          builder: (final _, final position) {
            if (position == null) {
              return const LoadingWidget();
            }
            final lastPosition = _lastPosition;
            if (lastPosition == null ||
                Geolocator.distanceBetween(
                      position.latitude,
                      position.longitude,
                      lastPosition.latitude,
                      lastPosition.longitude,
                    ) >=
                    position.accuracy) {
              _lastPosition = position;
              final lastSearchedPosition = _lastSearchedPosition;
              if (_elements == null ||
                  lastSearchedPosition == null ||
                  Geolocator.distanceBetween(
                        position.latitude,
                        position.longitude,
                        lastSearchedPosition.latitude,
                        lastSearchedPosition.longitude,
                      ) >=
                      widget.searchDistanceThreshold) {
                _overpass
                    .getNearbyNodes(
                      latitude: position.latitude,
                      longitude: position.longitude,
                      radius: widget.searchRadius,
                    )
                    .then(
                      (final elements) => setState(
                        () => _elements = elements.elements ?? [],
                      ),
                    );
              }
              return ElementsListView(position: position, elements: _elements);
            }
            return ElementsListView(position: position, elements: _elements);
          },
          duration: const Duration(seconds: 5),
        ),
      );
}
