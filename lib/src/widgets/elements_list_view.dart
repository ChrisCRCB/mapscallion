import 'dart:convert';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_overpass/dart_overpass.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:geolocator/geolocator.dart';

/// A widget for showing map objects.
class ElementsListView extends StatelessWidget {
  /// Create an instance.
  const ElementsListView({
    required this.position,
    required this.elements,
    super.key,
  });

  /// The current position.
  final Position position;

  /// The elements to show.
  final List<Element>? elements;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final e = elements;
    if (e == null) {
      return const CenterText(
        text: 'Loading nodes...',
        autofocus: true,
      );
    }
    if (e.isEmpty) {
      return const CenterText(
        text: 'There is nothing to see here.',
        autofocus: true,
      );
    }
    e.sort(
      (final a, final b) => Geolocator.distanceBetween(
        a.lat!,
        a.lon!,
        position.latitude,
        position.longitude,
      ).compareTo(
        Geolocator.distanceBetween(
          b.lat!,
          b.lon!,
          position.latitude,
          position.longitude,
        ),
      ),
    );
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final element = e[index];
        final tags = element.tags!;
        final tagMap = tags.toJson();
        final map = tagMap.entries.where((final entry) {
          final value = entry.value?.toString();
          return value != null && value.trim().isNotEmpty;
        });
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          element.lat!,
          element.lon!,
        );
        final direction = (Geolocator.bearingBetween(
                  position.latitude,
                  position.longitude,
                  element.lat!,
                  element.lon!,
                ) /
                12)
            .floor();
        final int clockFace;
        if (direction > 0) {
          clockFace = 12 - direction;
        } else {
          clockFace = direction;
        }
        final String title;
        final name = tags.name ?? 'Unnamed';
        final addressDetails = [
          tags.addrHousenumber,
          tags.addrStreet,
          tags.addrPostcode,
        ].whereType<String>();
        if (tags.amenity != null) {
          title = '$name ${tags.amenity}';
        } else if (addressDetails.isNotEmpty) {
          title = addressDetails.join(', ');
        } else {
          title = name;
        }
        final autofocus = index == 0;
        return Semantics(
          liveRegion: autofocus,
          child: ListTile(
            autofocus: autofocus,
            title: Text(title),
            subtitle: Text("${distance.floor()} m at $clockFace o'clock"),
            onTap: () => setClipboardText(
              const JsonEncoder.withIndent('  ').convert(map),
            ),
          ),
        );
      },
      itemCount: e.length,
      shrinkWrap: true,
    );
  }
}
