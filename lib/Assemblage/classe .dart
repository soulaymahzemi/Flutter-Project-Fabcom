

import 'dart:ui';

class ListItem {
  final String title;
  final String subtitle;
  final dynamic value;
  final Color shadowColor; // Add shadow color property

  ListItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.shadowColor  // Default to black if no color is provided
  });

}