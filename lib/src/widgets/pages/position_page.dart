import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../position_list_view.dart';
import '../timed_location_builder.dart';

/// A page which shows the current position.
class PositionPage extends StatelessWidget {
  /// Create an instance.
  const PositionPage({
    required this.updatePosition,
    this.initialPosition,
    this.locationUpdateDuration = const Duration(seconds: 10),
    super.key,
  });

  /// The function to call to update the position.
  final UpdatePosition updatePosition;

  /// The initial position to use.
  final Position? initialPosition;

  /// How often location should be updated.
  final Duration locationUpdateDuration;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TimedLocationBuilder(
        builder: (final context, final position) {
          if (position == null) {
            return const LoadingWidget();
          }
          return PositionListView(position: position);
        },
        duration: locationUpdateDuration,
        onUpdatePosition: updatePosition,
        initialPosition: initialPosition,
      );
}
