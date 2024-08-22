import 'package:flutter/material.dart';

/// A [ListTile] which is possibly [live].
class PossiblyLiveListTile extends StatelessWidget {
  /// Create an instance.
  const PossiblyLiveListTile({
    required this.title,
    required this.subtitle,
    required this.live,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  /// The title of the [ListTile].
  final String title;

  /// The subtitle of the [ListTile].
  final String subtitle;

  /// Whether this [ListTile] is a live region.
  final bool live;

  /// What to do when [live] changes.
  final ValueChanged<bool> onChanged;

  /// Whether the [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Semantics(
        liveRegion: live,
        child: ListTile(
          autofocus: autofocus,
          selected: live,
          title: Text(title),
          subtitle: Text(subtitle),
          onTap: () => onChanged(!live),
        ),
      );
}
