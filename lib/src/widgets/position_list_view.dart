import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../extensions.dart';
import 'possibly_live_list_tile.dart';

/// A [ListView] widget which shows [position].
class PositionListView extends StatefulWidget {
  /// Create an instance.
  const PositionListView({
    required this.position,
    super.key,
  });

  /// The position to show.
  final Position position;

  @override
  State<PositionListView> createState() => _PositionListViewState();
}

class _PositionListViewState extends State<PositionListView> {
  late bool _latitudeLive;
  late bool _longitudeLive;
  late bool _headingLive;
  late bool _speedLive;
  late bool _accuracyLive;
  late bool _altitudeLive;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _latitudeLive = false;
    _longitudeLive = false;
    _headingLive = false;
    _speedLive = false;
    _accuracyLive = false;
    _altitudeLive = false;
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final speed = (widget.position.speed * 3.6).toStringAsFixed(1);
    return ListView(
      shrinkWrap: true,
      children: <PossiblyLiveListTile>[
        PossiblyLiveListTile(
          title: 'Latitude',
          subtitle: widget.position.latitude.toString(),
          live: _latitudeLive,
          onChanged: (final value) => setState(
            () => _latitudeLive = value,
          ),
          autofocus: true,
        ),
        PossiblyLiveListTile(
          title: 'Longitude',
          subtitle: widget.position.longitude.toString(),
          live: _longitudeLive,
          onChanged: (final value) => setState(() => _longitudeLive = value),
        ),
        PossiblyLiveListTile(
          title: 'Heading',
          subtitle: widget.position.heading.floor().clockFace,
          live: _headingLive,
          onChanged: (final value) => setState(() => _headingLive = value),
        ),
        PossiblyLiveListTile(
          title: 'Speed',
          subtitle: '$speed kph',
          live: _speedLive,
          onChanged: (final value) => setState(() => _speedLive = value),
        ),
        PossiblyLiveListTile(
          title: 'Accuracy',
          subtitle: '${widget.position.accuracy} m',
          live: _accuracyLive,
          onChanged: (final value) => setState(() => _accuracyLive = value),
        ),
        PossiblyLiveListTile(
          title: 'Altitude',
          subtitle: widget.position.altitude.round().toString(),
          live: _altitudeLive,
          onChanged: (final value) => setState(() => _altitudeLive = value),
        ),
      ],
    );
  }
}
