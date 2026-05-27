import 'package:flutter/material.dart';
import 'package:helaruth/constants/colors.dart';
import 'package:helaruth/constants/text_styles.dart';
import 'package:helaruth/models/word_model.dart';
import 'package:helaruth/services/database_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';

class ResultPage extends StatefulWidget {
  final WordModel word;

  const ResultPage({super.key, required this.word});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final FlutterTts _tts = FlutterTts();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _checkIfFavorite();
    _addToHistory();
  }

  Future<void> _initializeTts() async {
    await _tts.setLanguage('si-LK');
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _checkIfFavorite() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'favorites_table',
      where: 'word_id = ?',
      whereArgs: [widget.word.id],
    );
    setState(() {
      _isFavorite = result.isNotEmpty;
    });
  }

  Future<void> _addToHistory() async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      'history_table',
      {
        'word_id': widget.word.id,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _toggleFavorite() async {
    final db = await DatabaseService.instance.database;
    if (_isFavorite) {
      await db.delete(
        'favorites_table',
        where: 'word_id = ?',
        whereArgs: [widget.word.id],
      );
    } else {
      await db.insert(
        'favorites_table',
        {'word_id': widget.word.id},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _pronounceWord() async {
    await _tts.speak(widget.word.word);
  }

  void _shareWord() {
    Share.share('${widget.word.word}\n${widget.word.meanings}');
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.word.word,
          style: AppTextStyles.sinhala.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareWord,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.word.word,
                  style: AppTextStyles.sinhala.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.star : Icons.star_border,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  widget.word.pronunciation,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.blue),
                  onPressed: _pronounceWord,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.word.meanings,
              style: AppTextStyles.sinhala.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}