import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_overpass/dart_overpass.dart';
import 'package:flutter/material.dart' hide Element;

/// A widget for showing map objects.
class ElementsListView extends StatelessWidget {
  /// Create an instance.
  const ElementsListView({
    required this.elements,
    super.key,
  });

  /// The elements to show.
  final List<Element>? elements;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final e = elements;
    if (e == null) {
      return const LoadingWidget();
    }
    if (e.isEmpty) {
      return const CenterText(
        text: 'There is nothing to see here.',
        autofocus: true,
      );
    }
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final element = e[index];
        final tags = element.tags;
        final map = tags?.toJson() ?? {};
        final information = map.entries
            .where((final entry) {
              final value = entry.value?.toString();
              return value != null && value.trim().isNotEmpty;
            })
            .map((final entry) => '${entry.key}: ${entry.value}')
            .toList();
        return CopyListTile(
          title: information.join(', '),
          subtitle: element.type ?? '<unknown>',
          autofocus: index == 0,
        );
      },
      itemCount: e.length,
      shrinkWrap: true,
    );
  }
}
