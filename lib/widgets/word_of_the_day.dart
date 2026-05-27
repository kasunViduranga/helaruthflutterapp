import 'package:flutter/material.dart';
import 'package:helaruth/constants/strings.dart';
import 'package:helaruth/models/word_model.dart';

class WordOfTheDay extends StatelessWidget {
  final WordModel? word;

  const WordOfTheDay({super.key, this.word});

  @override
  Widget build(BuildContext context) {
    if (word == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.wordOfTheDay,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            word!.word,
            style: const TextStyle(fontSize: 30, fontFamily: 'IskoolaPota'),
          ),
          const SizedBox(height: 10),
          Text(
            word!.meanings,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}