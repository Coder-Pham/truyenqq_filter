import 'dart:io';

import 'package:meta/meta.dart';

class Story {
  final String title;
  final String link;
  final dynamic chapter;
  final List<String> tags;
  final String image;

  Story({
    @required this.title,
    @required this.link,
    @required this.chapter,
    this.tags,
    this.image,
  });

  int compareTo(other) => this.chapter.compareTo(other.chapter);
}
