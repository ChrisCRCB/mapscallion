import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/position_list_view.dart';
import '../widgets/timed_location_builder.dart';

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
  /// The last position used.
  Position? _lastPosition;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SimpleScaffold(
        title: 'Location',
        body: TimedLocationBuilder(
          builder: (final _, final position) {
            final lastPosition = _lastPosition;
            if (position == null) {
              if (lastPosition == null) {
                return const LoadingWidget();
              }
              return PositionListView(position: lastPosition);
            }
            if (lastPosition == null ||
                Geolocator.distanceBetween(
                      position.latitude,
                      position.longitude,
                      lastPosition.latitude,
                      lastPosition.longitude,
                    ) >=
                    lastPosition.accuracy) {
              return PositionListView(position: position);
            }
            return PositionListView(position: lastPosition);
          },
          duration: const Duration(seconds: 5),
        ),
      );
}
