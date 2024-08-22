import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_overpass/dart_overpass.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:geolocator/geolocator.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

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
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          element.lat!,
          element.lon!,
        );
        final direction = Geolocator.bearingBetween(
              position.latitude,
              position.longitude,
              element.lat!,
              element.lon!,
            ) %
            360;
        final clockFace = (direction / 30).round();
        final String title;
        final name = tags.name ?? 'Unnamed';
        final addressDetails = [
          tags.addrHousenumber,
          tags.addrStreet,
          tags.addrPostcode,
        ].whereType<String>();
        final amenity = tags.amenity;
        if (amenity != null) {
          final String amenityString;
          if (amenity.contains('_')) {
            amenityString = amenity.titleCase;
          } else {
            amenityString = amenity;
          }
          title = '$name $amenityString';
        } else if (addressDetails.isNotEmpty) {
          title = addressDetails.join(', ');
        } else {
          title = name;
        }
        final website = tags.website;
        final autofocus = index == 0;
        return Semantics(
          liveRegion: autofocus,
          child: ListTile(
            autofocus: autofocus,
            title: Text('$title${website == null ? "" : " ($website)"}'),
            subtitle: Text(
              "${distance.floor()} m at $clockFace  o'clock",
            ),
            onTap: () {
              if (website != null) {
                final uri = Uri.tryParse(website);
                if (uri != null) {
                  launchUrl(uri);
                }
              }
            },
          ),
        );
      },
      itemCount: e.length,
      shrinkWrap: true,
    );
  }
}
