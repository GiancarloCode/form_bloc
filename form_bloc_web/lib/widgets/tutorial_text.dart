import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TutorialText extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  const TutorialText(
    this.text, {
    Key? key,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 12),
  }) : super(key: key);

  factory TutorialText.sub(String text) =>
      TutorialText(text, padding: const EdgeInsets.fromLTRB(0, 12, 0, 12));

  factory TutorialText.header(String text) =>
      TutorialText(text, padding: const EdgeInsets.fromLTRB(0, 12, 0, 12));

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: text.trim(),
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontFamily: 'JosefinSans',
        ),
        listBullet: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontFamily: 'JosefinSans',
        ),
        p: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontFamily: 'JosefinSans',
        ),
        code: TextStyle(
          fontSize: 18,
          backgroundColor: Colors.grey.shade200,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
