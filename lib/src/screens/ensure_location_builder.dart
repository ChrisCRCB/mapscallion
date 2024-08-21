import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// A screen which ensures location settings are as they should be, and then
/// builds [builder].
class EnsureLocationBuilder extends StatefulWidget {
  /// Create an instance.
  const EnsureLocationBuilder({
    required this.builder,
    super.key,
  });

  /// The widget builder to build when location settings are sorted.
  final WidgetBuilder builder;

  /// Create state for this widget.
  @override
  EnsureLocationBuilderState createState() => EnsureLocationBuilderState();
}

/// State for [EnsureLocationBuilder].
class EnsureLocationBuilderState extends State<EnsureLocationBuilder> {
  /// Whether or not the service is enabled.
  bool? _serviceEnabled;

  /// The permissions which have been granted.
  LocationPermission? _locationPermission;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final serviceEnabled = _serviceEnabled;
    if (_serviceEnabled == null) {
      Geolocator.isLocationServiceEnabled().then(
        (final value) => setState(() => _serviceEnabled = value),
      );
      return const LoadingScreen();
    }
    if (serviceEnabled == false) {
      return const SimpleScaffold(
        title: 'Error',
        body: CenterText(
          text:
              'The location service is disabled. Enable it before continuing.',
          autofocus: true,
        ),
      );
    }
    // The location service is enabled.
    final locationPermission = _locationPermission;
    if (locationPermission == null) {
      Geolocator.checkPermission().then(
        (final value) => setState(() => _locationPermission = value),
      );
    }
    if (locationPermission == LocationPermission.denied) {
      return SimpleScaffold(
        title: 'Request Permission',
        body: const CenterText(
          text: 'You must grant the app location permissions in order to work.',
          autofocus: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final permission = await Geolocator.requestPermission();
            setState(() {
              _locationPermission = permission;
            });
          },
          tooltip: 'Request Permission',
          child: const Icon(Icons.add),
        ),
      );
    }
    return widget.builder(context);
  }
}
