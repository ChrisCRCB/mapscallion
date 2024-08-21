import 'package:dart_overpass/dart_overpass.dart';
import 'package:geolocator/geolocator.dart';

/// A class which holds a [position] and a list of [elements].
class PositionedElements {
  /// Create an instance.
  const PositionedElements({
    required this.position,
    required this.elements,
  });

  /// The position which was used.
  final Position position;

  /// The elements at [position].
  final List<Element> elements;
}
