import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline),
      h1: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          color: Theme.of(context).colorScheme.primary),
      h2: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
      h2Padding: const EdgeInsets.only(top: 16));
}

void Function(String, String?, String) linkHandler(BuildContext context) {
  return (String text, String? url, String title) {
    if (url == null) {
      return;
    }
    if (url.startsWith("http://") ||
        url.startsWith("https://") ||
        url.startsWith("tel:") ||
        url.startsWith("mailto:")) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else if (url.startsWith("/")) {
      Beamer.of(context, root: true).beamToNamed(url);
    }
  };
}

void showUndo(BuildContext context, String text, void Function() onUndo) {
  final textColor = HSLColor.fromColor(Theme.of(context).colorScheme.primary)
      .withLightness(0.5)
      .toColor();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 8),
      content: Text(text),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 24),
      action: SnackBarAction(
          label: 'UNDO', textColor: textColor, onPressed: onUndo)));
}
