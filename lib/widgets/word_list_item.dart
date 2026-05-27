import 'package:flutter/material.dart';
import 'package:helaruth/models/word_model.dart';

class WordListItem extends StatelessWidget {
  final WordModel word;
  final VoidCallback onTap;

  const WordListItem({super.key, required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        word.word,
        style: const TextStyle(fontFamily: 'IskoolaPota', fontSize: 18),
      ),
      onTap: onTap,
    );
  }
}