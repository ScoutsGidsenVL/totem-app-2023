import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

String getFirstLetter(String value) {
  if (value.isEmpty) return '#';
  var tag = value.substring(0, 1).toUpperCase();
  if (RegExp("[A-Z]").hasMatch(tag)) {
    return tag;
  } else {
    return "#";
  }
}

MarkdownStyleSheet markdownStyle(BuildContext context) {
  return MarkdownStyleSheet(
      p: const TextStyle(fontSize: 18),
      a: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          decoration: TextDecoration.underline),
      h2: TextStyle(
          fontSize: 24, color: Theme.of(context).colorScheme.secondary),
      h2Padding: const EdgeInsets.only(top: 8));
}
