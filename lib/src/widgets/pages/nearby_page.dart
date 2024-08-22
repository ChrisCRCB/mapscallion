import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_overpass/dart_overpass.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:geolocator/geolocator.dart';

import '../elements_list_view.dart';
import '../timed_location_builder.dart';

/// The page that shows nearby elements.
class NearbyPage extends StatefulWidget {
  /// Create an instance.
  const NearbyPage({
    required this.updatePosition,
    required this.updateElements,
    this.initialPosition,
    this.initialElements,
    this.locationUpdateDuration = const Duration(seconds: 5),
    this.searchRadius = 500.0,
    this.searchDistanceThreshold = 400.0,
    super.key,
  });

  /// The function to call to update the position.
  final UpdatePosition updatePosition;

  /// The function to call to update nearby elements.
  final void Function(List<Element> elements) updateElements;

  /// The initial elements to use.
  final List<Element>? initialElements;

  /// The initial position to use.
  final Position? initialPosition;

  /// How often location should be updated.
  final Duration locationUpdateDuration;

  /// The search radius for nearby nodes.
  final double searchRadius;

  /// How many metres the user must travel before a new node search is
  /// performed.
  final double searchDistanceThreshold;

  /// Create state for this widget.
  @override
  NearbyPageState createState() => NearbyPageState();
}

/// State for [NearbyPage].
class NearbyPageState extends State<NearbyPage> {
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
    _elements = widget.initialElements;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => TimedLocationBuilder(
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
                (final value) {
                  final elements = value.elements ?? [];
                  widget.updateElements(elements);
                  if (mounted) {
                    setState(
                      () => _elements = elements,
                    );
                  }
                },
              );
            }
            return ElementsListView(position: position, elements: _elements);
          }
          return ElementsListView(position: position, elements: _elements);
        },
        duration: widget.locationUpdateDuration,
        onUpdatePosition: widget.updatePosition,
        initialPosition: widget.initialPosition,
      );
}
