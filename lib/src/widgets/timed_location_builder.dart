import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// The type of a function which updates a position.
typedef UpdatePosition = void Function(Position position);

/// A widget which builds its [builder] with a location every [duration].
class TimedLocationBuilder extends StatefulWidget {
  /// Create an instance.
  const TimedLocationBuilder({
    required this.builder,
    required this.duration,
    required this.onUpdatePosition,
    this.initialPosition,
    super.key,
  });

  /// The builder to use to construct the widget.
  final Widget Function(BuildContext context, Position? position) builder;

  /// How often the widget should be built.
  final Duration duration;

  /// The function to call with new positions.
  final UpdatePosition onUpdatePosition;

  /// The initial position to use.
  final Position? initialPosition;

  /// Create state for this widget.
  @override
  TimedLocationBuilderState createState() => TimedLocationBuilderState();
}

/// State for [TimedLocationBuilder].
class TimedLocationBuilderState extends State<TimedLocationBuilder> {
  /// The timer to use.
  late final Timer _timer;

  /// The current position.
  Position? _position;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _timer = Timer.periodic(widget.duration, (final _) async {
      final position = await Geolocator.getCurrentPosition();
      widget.onUpdatePosition(position);
      _position = position;
      setState(() {});
    });
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) =>
      widget.builder(context, _position);
}
