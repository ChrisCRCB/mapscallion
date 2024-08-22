import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../extensions.dart';

/// A [ListView] widget which shows [position].
class PositionListView extends StatelessWidget {
  /// Create an instance.
  const PositionListView({
    required this.position,
    super.key,
  });

  /// The position to show.
  final Position position;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Semantics(
            liveRegion: true,
            child: CopyListTile(
              autofocus: true,
              title: 'Latitude',
              subtitle: position.latitude.toString(),
            ),
          ),
          Semantics(
            liveRegion: true,
            child: CopyListTile(
              title: 'Longitude',
              subtitle: position.longitude.toString(),
            ),
          ),
          CopyListTile(
            title: 'Heading',
            subtitle: position.heading.floor().clockFace,
          ),
          CopyListTile(
            title: 'Accuracy',
            subtitle: position.accuracy.toString(),
          ),
        ],
      );
}
