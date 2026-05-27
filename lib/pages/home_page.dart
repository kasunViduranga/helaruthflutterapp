import 'package:flutter/material.dart';
import 'package:helaruth/constants/colors.dart';
import 'package:helaruth/constants/strings.dart';
import 'package:helaruth/constants/text_styles.dart';
import 'package:helaruth/services/database_service.dart';
import 'package:helaruth/models/word_model.dart';
import 'package:helaruth/pages/result_page.dart';
import 'package:helaruth/widgets/side_nav_bar.dart';
import 'package:helaruth/widgets/word_of_the_day.dart';
import 'package:helaruth/widgets/word_list_item.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isSearchFocused = false;
  bool _isListening = false;
  List<WordModel> _words = [];
  List<WordModel> _filteredWords = [];
  int _currentPage = 1;
  final int _itemsPerPage = 20; // Pagination
  final ScrollController _scrollController = ScrollController();
  WordModel? _wordOfTheDay;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _loadWordOfTheDay();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );
    if (!available) {
      print('Speech recognition not available');
    }
  }

  Future<void> _loadWordOfTheDay() async {
    final db = await DatabaseService.instance.database;
    final result = await db.rawQuery('SELECT * FROM words_table ORDER BY RANDOM() LIMIT 1');
    if (result.isNotEmpty) {
      setState(() {
        _wordOfTheDay = WordModel.fromMap(result.first);
      });
    }
  }

  Future<void> _loadWords({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _words.clear();
      _filteredWords.clear();
    }
    final offset = (_currentPage - 1) * _itemsPerPage;
    final db = await DatabaseService.instance.database;
    final result = await db.rawQuery(
      'SELECT * FROM words_table ORDER BY word ASC LIMIT ? OFFSET ?',
      [_itemsPerPage, offset],
    );
    setState(() {
      _words.addAll(result.map((e) => WordModel.fromMap(e)).toList());
      _filteredWords = _words;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _currentPage++;
      _loadWords();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredWords = _words
          .where((word) =>
              word.word.toLowerCase().startsWith(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech Status: $status');
          if (status == 'done') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) => print('Speech Error: $error'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _searchController.text = result.recognizedWords;
            });
          },
          localeId: 'si_LK', // Sinhala locale
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      final word = _filteredWords.firstWhere(
        (word) => word.word.toLowerCase() == value.toLowerCase(),
        orElse: () => WordModel(id: -1, word: '', meanings: '', pronunciation: ''),
      );
      if (word.id != -1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(word: word),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onSubmitted: _onSearchSubmitted,
                onTap: () {
                  setState(() {
                    _isSearchFocused = true;
                    _loadWords(reset: true);
                  });
                },
                decoration: InputDecoration(
                  hintText: AppStrings.searchPlaceholder,
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: _isSearchFocused
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _isSearchFocused = false;
                              _searchController.clear();
                              _filteredWords = [];
                            });
                          },
                        )
                      : Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                  suffixIcon: _isSearchFocused
                      ? IconButton(
                          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                          onPressed: _startListening,
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: _isSearchFocused
                  ? _filteredWords.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredWords.length,
                          itemBuilder: (context, index) {
                            final word = _filteredWords[index];
                            return WordListItem(
                              word: word,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(word: word),
                                  ),
                                );
                              },
                            );
                          },
                        )
                  : WordOfTheDay(word: _wordOfTheDay),
            ),
          ],
        ),
      ),
    );
  }
}